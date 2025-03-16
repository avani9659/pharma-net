'use strict';

const {Contract} = require('fabric-contract-api');

//Hierarchy of entities
const Manufacturer = 1;
const Distributor = 2;
const Retailer = 3;

class TransferDrugContract extends Contract{
    constructor(){
        super('pharmanet.transferdrug');
    }

    async instantiate(ctx) {
		console.log('Transfer Drug smart contract instantiated');
	}

    /**
     * create PO for drug
     * @param {*} ctx 
     * @param {*} buyerCRN CRN of buyer
     * @param {*} sellerCRN CRN of seller
     * @param {*} drugName name of the drug
     * @param {*} quantity quantity of druf for which PO needs to be created
     * @param {*} buyerName name of buyer
     * @param {*} sellerName name of seller
     * @returns 
     */
    async createPO(ctx, buyerCRN, sellerCRN, drugName, quantity, buyerName, sellerName){
        //check the mspId of the entity invoking this function
        let mspId = ctx.clientIdentity.getMSPID();
        if(mspId !== 'retailerMSP' && mspId !== 'distributorMSP'){
            return 'Only Retailers or Distributors can create PO. Cannot process the request';
        }

        //#region Validate buyer using buyer CRN
        const buyerKey = ctx.stub.createCompositeKey('pharmanet.company', [buyerCRN, buyerName]);
        const buyerBuffer = await ctx.stub.getState(buyerKey);

        if(!buyerBuffer){
            return 'Buyer is not part of the network. Cannot process the request';
        }

        const buyerJSON = JSON.parse(buyerBuffer.toString());
        let buyerRole = buyerJSON.organisationRole;

        if(buyerRole !== 'Distributor' && buyerRole !== 'Retailer'){
            return 'Buyer CRN does not belong to Distributor or Retailer. Cannot process the request';
        }
        //#endregion

        //#region Validate seller using seller CRN
        const sellerKey = ctx.stub.createCompositeKey('pharmanet.company', [sellerCRN, sellerName]);
        const sellerBuffer = await ctx.stub.getState(sellerKey);

        if(!sellerBuffer){
            return 'Seller is not part of the network. Cannot process the request';
        }

        const sellerJSON = JSON.parse(sellerBuffer.toString());
        let sellerRole = sellerJSON.organisationRole;

        if(sellerRole !== 'Distributor' && sellerRole !== 'Manufacturer'){
            return 'Seller CRN does not belong to Distributor or Manufacturer. Cannot process the request';
        }
        //#endregion

        //#region Validate drug transfer hierarchy
        const buyerHierarchyKey = buyerJSON.hierarchyKey;
        const sellerHierarchyKey = sellerJSON.hierarchyKey;

        if(sellerHierarchyKey === Manufacturer && buyerHierarchyKey !== Distributor){
            return 'PO can only be created between Manufacturer and Distributor';
        }

        if(sellerHierarchyKey === Distributor && buyerHierarchyKey !== Retailer){
            return 'PO can only be created between Distributor and Retailer';
        }
        //#endregion

        const poKey = ctx.stub.createCompositeKey('pharmanet.po', [buyerCRN, drugName]);
        const poObject = {
            docType: 'PO',
            poID: poKey,
            drugName: drugName,
            quantity: quantity,
            buyer: buyerKey,
            seller: sellerKey,
            createdAt: ctx.stub.getTxTimestamp()
        };

        await ctx.stub.putState(poKey, Buffer.from(JSON.stringify(poObject)));

        return poObject;
    }

    /**
     * Create shipment based on PO
     * @param {*} ctx 
     * @param {*} buyerCRN CRN of buyer
     * @param {*} drugName name of the drug
     * @param {*} listOfAssets list of assets for which shipment needs to be created. This will have the serial numbers of drugs
     * @param {*} transporterCRN CRN of transporter
     * @param {*} transporterName name of transporter
     * @returns 
     */
    async createShipment(ctx, buyerCRN, drugName, listOfAssets, transporterCRN, transporterName){
        //check the mspId of entity invoking this function
        let mspId = ctx.clientIdentity.getMSPID();
        if(mspId !== 'manufacturerMSP' && mspId !== 'distributorMSP'){
            return 'Only manufacturers or Distributors can create shipment. Cannot process the request';
        }

        //#region check if PO exists on the network
        const poKey = ctx.stub.createCompositeKey('pharmanet.po', [buyerCRN, drugName]);
        const poBuffer = await ctx.stub.getState(poKey);
        if(!poBuffer){
            return 'Shipment can only be created after PO is created. Cannot process the request.';   
        }

        let poJSON = JSON.parse(poBuffer.toString());
        //#endregion

        //#region Validate if transporter exists on the network
        const transporterKey = ctx.stub.createCompositeKey('pharmanet.company', [transporterCRN, transporterName]);
        const transporterBuffer = await ctx.stub.getState(transporterKey);

        if(!transporterBuffer){
            return 'Transporter is not part of the network. Cannot process the request';
        }

        const transporterJSON = JSON.parse(transporterBuffer.toString());
        let transporterRole = transporterJSON.organisationRole;

        if(transporterRole !== 'Transporter'){
            return 'Provided CRN does not belong to transporter. Cannot process the request';
        }
        //#endregion

        //#region Valid listOfAssets
        let keys = listOfAssets.split(',');
        let assetArray = [];

        let poQuantity = parseInt(poJSON.quantity);

        if(poQuantity === NaN || keys.length !== poQuantity){
            return 'Quantity in PO does not match with asset list passed. Cannot process the request.';
        }
        //#endregion

        //#region Validate the keys provided in listOfAssets.
        for(let key of keys){
            const drugKey = ctx.stub.createCompositeKey('pharmanet.drug', [drugName, key]);
            const drugBuffer = await ctx.stub.getState(drugKey);
            if(!drugBuffer){
                return 'listOfAssets contains invalid key. Cannot process the request';
            }

            assetArray.push(drugKey);
        }

        //#endregion

        const shipmentKey = ctx.stub.createCompositeKey('pharmanet.shipment', [buyerCRN, drugName]);
        const shipmentObject = {
            docType: 'shipment',
            shipmentID: shipmentKey,
            creator: poJSON.seller, //only sellers can create shipments
            assets: assetArray,
            transporter: transporterKey,
            status: 'in-transit',
            createdAt: ctx.stub.getTxTimestamp(),
            updatedAt: ctx.stub.getTxTimestamp()
        }

        await ctx.stub.putState(shipmentKey, Buffer.from(JSON.stringify(shipmentObject)));

        //update the owner in drug asset
        await this.#updateDrugOwnerAndShipment(ctx, assetArray, transporterKey);

        return shipmentObject;
    }

    /**
     * Update the shipment to set the status as 'delivered'
     * @param {*} ctx 
     * @param {*} buyerCRN CRN of the buyer
     * @param {*} drugName name of the drug
     * @param {*} transporterCRN CRN of transporter
     * @param {*} buyerName name of buyer
     * @param {*} transporterName name of trabsporter
     * @returns 
     */
    async updateShipment(ctx, buyerCRN, drugName, transporterCRN, buyerName, transporterName){
        //get the mspId of entity initiating the transaction
        let mspId = ctx.clientIdentity.getMSPID();
        if(mspId !== 'transporterMSP'){
            return 'Only Transporters can create shipment. Cannot process the request';
        }

        //#region Validate the transporter
        const transporterKey = ctx.stub.createCompositeKey('pharmanet.company', [transporterCRN, transporterName]);
        const transporterBuffer = await ctx.stub.getState(transporterKey);

        if(!transporterBuffer){
            return 'Transporter is not part of the network. Cannot process the request';
        }

        const transporterJSON = JSON.parse(transporterBuffer.toString());
        let transporterRole = transporterJSON.organisationRole;

        if(transporterRole !== 'Transporter'){
            return 'Provided CRN does not belong to transporter. Cannot process the request';
        }
        //#endregion

        //#region check if shipment exists
        const shipmentKey = ctx.stub.createCompositeKey('pharmanet.shipment', [buyerCRN, drugName]);
        const shipmentBuffer = await ctx.stub.getState(shipmentKey);
        if(!shipmentBuffer){
            return 'Shipment does not exist in the network. Cannot process the request';
        }

        let shipmentJSON = JSON.parse(shipmentBuffer.toString());
        //#endregion

        //only creator of shipment can update the shipment
        if(shipmentJSON.transporter !== transporterKey){
            return 'Shipment can be updated only the creator of shipment. Cannot process the request';
        }

        //shipment should be 'in-transit' when updating the shipment
        if(shipmentJSON.status !== 'in-transit'){
            return ('The shipment is already delivered. Cannot process the request');
        }

        const buyerKey = ctx.stub.createCompositeKey('pharmanet.company', [buyerCRN, buyerName]);
        const buyerBuffer = await ctx.stub.getState(buyerKey);
        if(!buyerBuffer){
            return 'Buyer does not exist in the network. Cannot process the request.'
        }

        //update shipment
        shipmentJSON.status = 'delivered';
        shipmentJSON.updatedAt = ctx.stub.getTxTimestamp();

        await ctx.stub.putState(shipmentKey, Buffer.from(JSON.stringify(shipmentJSON)));

        //update drug shipments and owner
        await this.#updateDrugOwnerAndShipment(ctx, shipmentJSON.assets, buyerKey, shipmentKey);

        return shipmentJSON;
    }

    /**
     * Retail the drugs to customer
     * @param {*} ctx 
     * @param {*} drugName name of the drug to be sold
     * @param {*} serialNo serial number of the drug to be sold
     * @param {*} retailerCRN CRN of retailer
     * @param {*} customerAadhar aadhar of customer (will become the final owner of drug)
     * @param {*} retailerName name of the retailer selling the drug
     * @returns 
     */
    async retailDrug(ctx, drugName, serialNo, retailerCRN, customerAadhar, retailerName){
        let mspId = ctx.clientIdentity.getMSPID();
        if(mspId !== 'retailerMSP'){
            return 'Only Retailers can inoke this transaction. Cannot process the request';
        }

        //#region Validate retailer
        const retailerKey = ctx.stub.createCompositeKey('pharmanet.company', [retailerCRN, retailerName]);
        const retailerBuffer = await ctx.stub.getState(retailerKey);

        if(!retailerBuffer){
            return 'Retailer is not part of the network. Cannot process the request';
        }

        const retailerJSON = JSON.parse(retailerBuffer.toString());
        let retailerRole = retailerJSON.organisationRole;

        if(retailerRole !== 'Retailer'){
            return 'Provided CRN does not belong to retailer. Cannot process the request';
        }
        //#endregion

        //#region Validate if the given drug exists in network and if the owner of drug is retailer
        const drugKey = ctx.stub.createCompositeKey('pharmanet.drug', [drugName, serialNo]);
        const drugBuffer = await ctx.stub.getState(drugKey);
        if(!drugBuffer){
            return 'Drug is not part of the network. Cannot process the request';
        }

        let drugJSON = JSON.parse(drugBuffer.toString());
        if(drugJSON.owner !== retailerKey){
            return 'This retailer does not own this drug. Cannot process the request';
        }
        //#endregion

        drugJSON.owner = customerAadhar;
        drugJSON.updatedAt = ctx.stub.getTxTimestamp();

        await ctx.stub.putState(drugKey, Buffer.from(JSON.stringify(drugJSON)));

        return drugJSON;
    }

    /**
     * Private method used to update drug ownership and shipment key at various stages of supply chain process
     * @param {*} ctx 
     * @param {*} drugList list of drug asset keys
     * @param {*} ownerKey owner key to be updated in drug object
     * @param {*} shipmentKey shipment key to be added in drug object
     */
    async #updateDrugOwnerAndShipment(ctx, drugList, ownerKey, shipmentKey){
        for(let key of drugList){
            const drugBuffer = await ctx.stub.getState(key);
            const drugJSON = JSON.parse(drugBuffer.toString());

            drugJSON.owner = ownerKey;
            drugJSON.updatedAt = ctx.stub.getTxTimestamp();
            if(shipmentKey !== null && shipmentKey !== undefined){
                drugJSON.shipment.push(shipmentKey);
            }

            await ctx.stub.putState(key, Buffer.from(JSON.stringify(drugJSON)));
        }
    }
}


module.exports = TransferDrugContract;