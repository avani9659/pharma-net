'use strict';

const helper = require('./contractHelper');

async function main(buyerCRN, drugName, transporterCRN, buyerName, transporterName, organisationRole){
    try{
        const contract = await helper.getContractInstance(organisationRole, 'pharmanet.transferdrug');
        const responseBuffer = await contract.submitTransaction('updateShipment', buyerCRN, drugName, transporterCRN, buyerName, transporterName);
    
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