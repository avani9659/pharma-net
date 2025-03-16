'use strict';

const helper = require('./contractHelper');

async function main(drugName, serialNo, retailerCRN, customerAadhar, retailerName, organisationRole){
    try{
        const contract = await helper.getContractInstance(organisationRole, 'pharmanet.transferdrug');
        const responseBuffer = await contract.submitTransaction('retailDrug', drugName, serialNo, retailerCRN, customerAadhar, retailerName);
    
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