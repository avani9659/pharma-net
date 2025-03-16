#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true #gg
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/pharma-network.com/tlsca/tlsca.pharma-network.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/pharma-network.com/orderers/orderer.pharma-network.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/pharma-network.com/orderers/orderer.pharma-network.com/tls/server.key


# Where am I?
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

export PEER0_MANUFACTURER_CA=${PWD}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
export PEER0_DISTRIBUTER_CA=${PWD}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem
export PEER0_RETAILER_CA=${PWD}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
export PEER0_CONSUMER_CA=${PWD}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem
export PEER0_TRANSPORTER_CA=${PWD}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem

# Set environment variables for the peer org
setGlobals() {
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

  echo "$DIR and ${PWD}"
  local ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    ORG=$1
    PEER_NUM=$2
  else
    ORG="${OVERRIDE_ORG}"
    PEER_NUM=$2
  fi
  infoln "Using organization ${ORG} Peer ${PEER_NUM}"

  echo  "envVar.sh is setGlobals() setting  ${ORG} Peer ${PEER_NUM} vars to GLOBAL"
  if [[ ${ORG} == "manufacturer" && ${PEER_NUM} == 0 ]]; then
    CORE_PEER_LOCALMSPID=manufacturerMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/users/Admin@manufacturer.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:7051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=manufacturerMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/users/Admin@manufacturer.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem


  elif [[ ${ORG} == "manufacturer" && ${PEER_NUM} == 1 ]]; then
    CORE_PEER_LOCALMSPID=manufacturerMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/users/Admin@manufacturer.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:8051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=manufacturerMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/users/Admin@manufacturer.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem


  elif [[ ${ORG} == "distributor" && ${PEER_NUM} == 0 ]]; then
    CORE_PEER_LOCALMSPID=distributorMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/users/Admin@distributor.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:9051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=distributorMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/users/Admin@distributor.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem

  elif [[ ${ORG} == "distributor" && ${PEER_NUM} == 1 ]]; then
    CORE_PEER_LOCALMSPID=distributorMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/users/Admin@distributor.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:10051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=distributorMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/users/Admin@distributor.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem

  elif [[ ${ORG} == "retailer" && ${PEER_NUM} == 0 ]]; then
    CORE_PEER_LOCALMSPID=retailerMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/users/Admin@retailer.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:11051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.retailer.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=retailerMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/users/Admin@retailer.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.retailer.pharma-network.com-cert.pem

  elif [[ ${ORG} == "retailer" && ${PEER_NUM} == 1 ]]; then
    CORE_PEER_LOCALMSPID=retailerMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/users/Admin@retailer.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:12051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.retailer.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=retailerMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/users/Admin@retailer.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:12051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.retailer.pharma-network.com-cert.pem


  elif [[ ${ORG} == "consumer" && ${PEER_NUM} == 0 ]]; then
    CORE_PEER_LOCALMSPID=consumerMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/users/Admin@consumer.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:13051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.consumer.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=consumerMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/users/Admin@consumer.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.consumer.pharma-network.com-cert.pem

  elif [[ ${ORG} == "consumer" && ${PEER_NUM} == 1 ]]; then
    CORE_PEER_LOCALMSPID=consumerMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/users/Admin@consumer.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:14051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.consumer.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=consumerMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/users/Admin@consumer.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:14051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.consumer.pharma-network.com-cert.pem

  elif [[ ${ORG} == "transporter" && ${PEER_NUM} == 0 ]]; then
    CORE_PEER_LOCALMSPID=transporterMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/users/Admin@transporter.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:15051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.transporter.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=transporterMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/users/Admin@transporter.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:15051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.transporter.pharma-network.com-cert.pem

  elif [[ ${ORG} == "transporter" && ${PEER_NUM} == 1 ]]; then
    CORE_PEER_LOCALMSPID=transporterMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/users/Admin@transporter.pharma-network.com/msp
    CORE_PEER_ADDRESS=localhost:16051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.transporter.pharma-network.com-cert.pem
    export CORE_PEER_LOCALMSPID=transporterMSP
    export CORE_PEER_MSPCONFIGPATH=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/users/Admin@transporter.pharma-network.com/msp
    export CORE_PEER_ADDRESS=localhost:16051
    export CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.transporter.pharma-network.com-cert.pem

  else
    echo "Unknown \"$ORG\", please choose manufacturer or distributor or retailer or consumer or transporter"
    echo "For example to get the environment variables to set upa Distributor shell environment run:  ./setOrgEnv.sh Distributor"
    echo
    echo "This can be automated to set them as well with:"
    echo
    echo 'export $(./setOrgEnv.sh Distributor | xargs)'
    exit 1
  fi

  #### dhalan end
  

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi

}



# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1 $2

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG == "manufacturer" ]; then
    export CORE_PEER_ADDRESS=peer0.manufacturer.pharma-network.com:7051
  elif [ $USING_ORG == "distributor" ]; then
    export CORE_PEER_ADDRESS=peer0.distributor.pharma-network.com:9051
  elif [ $USING_ORG == "retailer" ]; then
    export CORE_PEER_ADDRESS=peer0.retailer.pharma-network.com:11051
  elif [ $USING_ORG == "consumer" ]; then
    export CORE_PEER_ADDRESS=peer0.consumer.pharma-network.com:13051
  elif [ $USING_ORG == "transporter" ]; then
    export CORE_PEER_ADDRESS=peer0.distributor.pharma-network.com:15051    
  else
    errorln "ORG Unknown"
  fi
}



# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_ORG$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}


verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
