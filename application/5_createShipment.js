'use strict';

const helper = require('./contractHelper');

async function main(buyerCRN, drugName, listOfAssets, transporterCRN, transporterName, organisationRole){
    try{
        const contract = await helper.getContractInstance(organisationRole, 'pharmanet.transferdrug');
        const responseBuffer = await contract.submitTransaction('createShipment', buyerCRN, drugName, listOfAssets, transporterCRN, transporterName);
    
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