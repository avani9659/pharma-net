'use strict';

const helper = require('./contractHelper');

async function main(drugName, serialNo, organisationRole){
    try{
        const contract = await helper.getContractInstance(organisationRole, 'pharmanet.viewlifecycle');
        const responseBuffer = await contract.submitTransaction('viewHistory', drugName, serialNo);
    
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