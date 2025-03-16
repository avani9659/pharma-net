'use strict';

const helper = require('./contractHelper');

async function main(buyerCRN, sellerCRN, drugName, quantity, buyerName, sellerName, organisationRole){
    try{
        const contract = await helper.getContractInstance(organisationRole, 'pharmanet.transferdrug');
        const responseBuffer = await contract.submitTransaction('createPO', buyerCRN, sellerCRN, drugName, quantity, buyerName, sellerName);
    
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