'use strict';

const {Contract} = require('fabric-contract-api');

class DrugRegistrationContract extends Contract{
    constructor(){
        super('pharmanet.drugregistration');
    }

    async instantiate(ctx) {
		console.log('Drug Registration smart contract instantiated');
	}

    /**
     * Used to add drug to network
     * @param {*} ctx 
     * @param {*} drugName Name of the drug to be added
     * @param {*} serialNo Serial number of the drug
     * @param {*} mfgDate manufacturing date of drug
     * @param {*} expDate expiry date of drug
     * @param {*} companyCRN CRN of company that is adding the drug
     * @param {*} companyName Name of the company that is adding drug
     * @returns 
     */
    async addDrug(ctx, drugName, serialNo, mfgDate, expDate, companyCRN, companyName){
        //gets the MSP ID from config files
        const mspId = ctx.clientIdentity.getMSPID();
        if(mspId !== "manufacturerMSP"){
            return 'Drug can be added in the ledger only by a manufacturer';
        }

        const manufacturerKey = ctx.stub.createCompositeKey('pharmanet.company', [companyCRN, companyName]);; //the composite key of manufacturer
        const manufacturerBuffer = await ctx.stub.getState(manufacturerKey);
        if(manufacturerBuffer){
            const manufacturerJSON = JSON.parse(manufacturerBuffer.toString());

            if(manufacturerJSON.organisationRole !== 'Manufacturer'){
                return 'The given CRN is not that of a manufacturer. cannot process the request';
            }

            const drugKey = ctx.stub.createCompositeKey('pharmanet.drug', [drugName, serialNo]);

            const drugObject = {
                docType: 'drug',
                productID: drugKey,
                name: drugName,
                manufacturer: manufacturerKey,
                manufacturingDate: mfgDate,
                expiryDate: expDate,
                owner: manufacturerKey,
                shipment: [],
                createdAt: ctx.stub.getTxTimestamp(),
                updatedAt: ctx.stub.getTxTimestamp()
            }

            await ctx.stub.putState(drugKey, Buffer.from(JSON.stringify(drugObject)));

            return drugObject;
        }
        else {
            return 'Cannot process the request';
        }        
    }
}

module.exports = DrugRegistrationContract;