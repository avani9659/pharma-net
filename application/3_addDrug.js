'use strict';

const helper = require('./contractHelper');

async function main(drugName, serialNo, mfgDate, expDate, companyCRN, companyName, organisationRole){
    try{
        const contract = await helper.getContractInstance(organisationRole, 'pharmanet.drugregistration');
        const responseBuffer = await contract.submitTransaction('addDrug', drugName, serialNo, mfgDate, expDate, companyCRN, companyName);
    
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