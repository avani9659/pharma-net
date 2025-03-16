'use strict';

const entityRegistrationContract = require('./entityRegistrationContract');
const drugRegistrationContract = require('./drugRegistrationContract');
const transferDrugContract = require('./transferDrugContract');
const viewLifeCycleContract = require('./viewLifecycleContract');

module.exports.contracts = [entityRegistrationContract, drugRegistrationContract, transferDrugContract, viewLifeCycleContract];