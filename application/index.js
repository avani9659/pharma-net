'use strict';

const express = require('express');
const app = express();
const cors = require('cors');
const port = 3000;

//import all function modules
const addToWallet = require('./1_addToWallet');
const registerCompany = require('./2_registerCompany');
const addDrug = require('./3_addDrug');
const createPO = require('./4_createPO');
const createShipment = require('./5_createShipment');
const updateShipment = require('./6_updateShipment');
const retailDrug = require('./7_retailDrug');
const viewHistory = require('./8_viewHistory');
const viewDrugCurrentState = require('./9_viewDrugCurrentState');

//define express app settings
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.set('title', 'Pharma App');

//define API endpoints
app.get('/', (req, res) => res.send('Welcome to Pharma App!!'));

app.post('/addToWallet', (req, res) => {
    addToWallet.execute(req.body.certificatePath, req.body.privateKeyPath, req.body.orgRole)
        .then(() => {
            console.log('Credentials added to wallet');
            const result = {
                status: 'success',
                message: 'Credentials added to wallet'
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'failed',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/registerCompany', (req, res) => {
    registerCompany.execute(req.body.companyCRN, req.body.companyName, req.body.location, req.body.organisationRole)
        .then ((company) => {
            console.log('Company Registered successfully');
            const result = {
                status: 'success',
                message: 'Company registered successfully',
                company: company
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to register company',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/addDrug', (req, res) => {
    addDrug.execute(req.body.drugName, req.body.serialNo, req.body.mfgDate, req.body.expDate, req.body.companyCRN, req.body.companyName, req.body.orgRole)
        .then ((drug) => {
            console.log('Drug added successfully');
            const result = {
                status: 'success',
                message: 'Drug Added successfully',
                drug: drug
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to add drug',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/createPO', (req, res) => {
    createPO.execute(req.body.buyerCRN, req.body.sellerCRN, req.body.drugName, req.body.quantity, req.body.buyerName, req.body.sellerName, req.body.orgRole)
        .then((po) => {
            console.log('PO created successfully');
            const result = {
                status: 'success',
                message: 'PO created successfully',
                po: po
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to create PO',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/createShipment', (req, res) => {
    createShipment.execute(req.body.buyerCRN, req.body.drugName, req.body.listOfAssets,req.body.transporterCRN, req.body.transporterName, req.body.orgRole)
        .then((shipment) => {
            console.log('Shipment created successfully');
            const result = {
                status: 'success',
                message: 'Shipment created successfully',
                shipment: shipment
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to create Shipment',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/updateShipment', (req, res) => {
    updateShipment.execute(req.body.buyerCRN, req.body.drugName, req.body.transporterCRN, req.body.buyerName, req.body.transporterName, req.body.orgRole)
        .then((shipment) => {
            console.log('Shipment updated successfully');
            const result = {
                status: 'success',
                message: 'Shipment updated successfully',
                shipment: shipment
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to update Shipment',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/retailDrug', (req, res) => {
    retailDrug.execute(req.body.drugName, req.body.serialNo,req.body.retailerCRN, req.body.customerAadhar, req.body.retailerName, req.body.orgRole)
        .then((retailDrug) => {
            console.log('Drug sold  successfully');
            const result = {
                status: 'success',
                message: 'Drug sold  successfully',
                retailDrug: retailDrug
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to retail drug',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/viewHistory', (req, res) => {
    viewHistory.execute(req.body.drugName, req.body.serialNo,req.body.orgRole)
        .then((history) => {
            console.log('Drug history fetched');
            const result = {
                status: 'success',
                message: 'drug history fetched',
                history: history
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to fetch drug history',
                error: e
            };
            res.status(500).send(result);
        });
});

app.post('/viewDrugCurrentState', (req, res) => {
    viewDrugCurrentState.execute(req.body.drugName, req.body.serialNo,req.body.orgRole)
        .then((currentState) => {
            console.log('Drug current state fetched');
            const result = {
                status: 'success',
                message: 'drug current state fetched',
                currentState: currentState
            };
            res.json(result);
        })
        .catch((e) => {
            const result = {
                status: 'error',
                message: 'Failed to fetch drug current state',
                error: e
            };
            res.status(500).send(result);
        });
});

//start the API server
app.listen(port, () => console.log(`Distributed Pharma App listening on port ${port}!!`));