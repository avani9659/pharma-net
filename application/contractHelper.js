'use strict';

const fs = require('fs'); 
const { Wallets, Gateway } = require('fabric-network');
const yaml = require('js-yaml');
let gateway;

async function getContractInstance(organisationRole, contractName){
    gateway = new Gateway();

    const orgRoleLower = organisationRole.toLowerCase();
    const connectionProfile = yaml.load(fs.readFileSync('./ccp/connection-'+orgRoleLower+'.yaml', 'utf8'));

    const wallet = await Wallets.newFileSystemWallet('./identity/'+orgRoleLower);

    const identityLabel = 'ADMIN_' + organisationRole.toUpperCase();

    const gatewayOptions = {
        wallet: wallet,
        identity: identityLabel,
        dicovery: {enabled: true, asLocalhost: true}
    }

    await gateway.connect(connectionProfile, gatewayOptions);

    const channel = await gateway.getNetwork('pharmachannel');

    return channel.getContract('pharmanet', contractName);
}

function disconnect(){
    gateway.disconnect();
}

module.exports.getContractInstance = getContractInstance;
module.exports.disconnect = disconnect;