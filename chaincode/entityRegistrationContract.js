'use strict';

const {Contract} = require('fabric-contract-api');

//Supported roles as part of registerCompany function
const roles = ["Manufacturer", "Distributor", "Retailer", "Transporter"];

class EntityRegistrationContract extends Contract{
    constructor(){
        super('pharmanet.entityregistration');
    }

    async instantiate(ctx) {
		console.log('Entity Registration smart contract instantiated');
	}

    /**
     * Register a new company on the network
     * @param {*} ctx 
     * @param {*} companyCRN CRN of company to be added
     * @param {*} companyName name of the company to be added
     * @param {*} location location of the company
     * @param {*} organisationRole specifies which org role the company belongs to
     * @returns 
     */
    async registerCompany(ctx, companyCRN, companyName, location, organisationRole){
        //check if company with valid role is being added
        if(!roles.includes(organisationRole)){
            return 'The given role is not part of pharma network. Cannot process the request';
        }

        const companyKey = ctx.stub.createCompositeKey('pharmanet.company', [companyCRN, companyName]);
        const hierarchyKey = this.#getHierarchyKey(organisationRole);

        const newCompanyObject = {
            docType: 'entity',
            companyID: companyKey,
            name: companyName,
            location: location,
            organisationRole: organisationRole,
            hierarchyKey: hierarchyKey,
            createdAt: ctx.stub.getTxTimestamp()
        };

        await ctx.stub.putState(companyKey, Buffer.from(JSON.stringify(newCompanyObject)));
        
        return newCompanyObject;
    }

    /**
     * Get the hierarchy key based on the organisation role
     * @param {*} orgRole 
     * @returns 
     */
    #getHierarchyKey(orgRole){
        switch(orgRole){
            case "Manufacturer":
                return 1;
            case "Distributor":
                return 2;
            case "Retailer":
                return 3;
            case "Transporter":
                return null;
        }
    }
}

module.exports = EntityRegistrationContract;