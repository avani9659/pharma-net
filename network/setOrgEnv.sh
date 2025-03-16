#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using manufacturer
ORG=${1:-manufacturer}
PEER_NUM=$2
# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/organizations/ordererOrganizations/pharma-network.com/tlsca/tlsca.pharma-network.com-cert.pem
PEER0_MANUFACTURER_CA=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
PEER0_DISTRIBUTER_CA=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem
PEER0_RETAILER_CA=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
PEER0_CONSUMER_CA=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem
PEER0_TRANSPORTER_CA=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
PEER0_ORG3_CA=${DIR}/organizations/peerOrganizations/org3.pharma-network.com/tlsca/tlsca.org3.pharma-network.com-cert.pem

infoln "Using organization ${ORG} Peer ${PEER_NUM}"

if [[ ${ORG} == "manufacturer" && ${PEER_NUM} == 0 ]]; then
   
   CORE_PEER_LOCALMSPID=manufacturerMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/users/Admin@manufacturer.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem

elif [[ ${ORG} == "manufacturer" && ${PEER_NUM} == 1 ]]; then
   CORE_PEER_LOCALMSPID=manufacturerMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/users/Admin@manufacturer.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:8051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem

elif [[ ${ORG} == "distributor" && ${PEER_NUM} == 0 ]]; then
   CORE_PEER_LOCALMSPID=distributorMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/users/Admin@distributor.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem

elif [[ ${ORG} == "distributor" && ${PEER_NUM} == 1 ]]; then
   CORE_PEER_LOCALMSPID=distributorMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/users/Admin@distributor.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:10051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem

elif [[ ${ORG} == "retailer" && ${PEER_NUM} == 0 ]]; then
   CORE_PEER_LOCALMSPID=retailerMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/users/Admin@retailer.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:11051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.retailer.pharma-network.com-cert.pem

elif [[ ${ORG} == "retailer" && ${PEER_NUM} == 1 ]]; then
   CORE_PEER_LOCALMSPID=retailerMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/users/Admin@retailer.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:12051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.retailer.pharma-network.com-cert.pem


elif [[ ${ORG} == "consumer" && ${PEER_NUM} == 0 ]]; then
   CORE_PEER_LOCALMSPID=consumerMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/users/Admin@consumer.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:13051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.consumer.pharma-network.com-cert.pem

elif [[ ${ORG} == "consumer" && ${PEER_NUM} == 1 ]]; then
   CORE_PEER_LOCALMSPID=consumerMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/users/Admin@consumer.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:14051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.consumer.pharma-network.com-cert.pem

elif [[ ${ORG} == "transporter" && ${PEER_NUM} == 0 ]]; then
   CORE_PEER_LOCALMSPID=transporterMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/users/Admin@transporter.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:15051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.transporter.pharma-network.com-cert.pem

elif [[ ${ORG} == "transporter" && ${PEER_NUM} == 1 ]]; then
   CORE_PEER_LOCALMSPID=transporterMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/users/Admin@transporter.pharma-network.com/msp
   CORE_PEER_ADDRESS=localhost:16051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.transporter.pharma-network.com-cert.pem

else
   echo "Unknown \"$ORG\", please choose manufacturer or distributor or retailer or consumer or transporter"
   echo "For example to get the environment variables to set upa Distributor shell environment run:  ./setOrgEnv.sh Distributor"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Distributor | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_MANUFACTURER_CA=${PEER0_MANUFACTURER_CA}"
echo "PEER0_DISTRIBUTER_CA=${PEER0_DISTRIBUTER_CA}"
echo "PEER0_RETAILER_CA=${PEER0_RETAILER_CA}"
echo "PEER0_CONSUMER_CA=${PEER0_CONSUMER_CA}"
echo "PEER0_TRANSPORTER_CA=${PEER0_TRANSPORTER_CA}"
echo "PEER0_ORG3_CA=${PEER0_ORG3_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
