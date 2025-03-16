'use strict';

const helper = require('./contractHelper');

async function main(companyCRN, companyName, location, organisationRole){
    try{
        const contract = await helper.getContractInstance(organisationRole, 'pharmanet.entityregistration');
        const responseBuffer = await contract.submitTransaction('registerCompany', companyCRN, companyName, location, organisationRole);
    
        return JSON.parse(responseBuffer.toString());
    }
    catch(e){
        console.log(e);
    }
    finally{
        helper.disconnect();
    }
    
}

module.exports.execute = main;