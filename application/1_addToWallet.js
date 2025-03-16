'use strict';

const fs = require('fs'); // FileSystem Library
const { Wallets } = require('fabric-network');

async function main(certificatePath, privateKeyPath, orgRole) {

	try {
		const orgRoleUpper = orgRole.toUpperCase();
		const orgRoleLower = orgRole.toLowerCase();

		const wallet = await Wallets.newFileSystemWallet('./identity/'+orgRoleLower);

		// Fetch the credentials from our previously generated Crypto Materials required to create identity
		const certificate = fs.readFileSync(certificatePath).toString();
		
		// IMPORTANT: Change the private key name to the key generated on your computer
		const privatekey = fs.readFileSync(privateKeyPath).toString();

		// Load credentials into wallet
		const identityLabel = 'ADMIN_' + orgRoleUpper;

		const identity = {
			credentials: {
				certificate: certificate,
				privateKey: privatekey
			},
			mspId: orgRoleLower+'MSP',
			type: 'X.509'
		}
		
		await wallet.put(identityLabel, identity);

	} catch (error) {
		console.log(`Error adding to wallet. ${error}`);
		console.log(error.stack);
	}
}

module.exports.execute = main;