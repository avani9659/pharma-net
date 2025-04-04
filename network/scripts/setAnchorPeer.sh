#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# import utils
. scripts/envVar.sh
. scripts/configUpdate.sh


# NOTE: this must be run in a CLI container since it requires jq and configtxlator  
createAnchorPeerUpdate() {
  infoln "Fetching channel config for channel $CHANNEL_NAME"
  fetchChannelConfig $ORG $CHANNEL_NAME ${CORE_PEER_LOCALMSPID}config.json 0

  infoln "Generating anchor peer update transaction for $ORG on channel $CHANNEL_NAME"

  if [ $ORG == "manufacturer" ]; then
    # manufacturer
    HOST="peer0.manufacturer.pharma-network.com"
    PORT=7051
    export HOST="peer0.manufacturer.pharma-network.com"
    export PORT=7051

  elif [ $ORG == "distributor" ]; then
    # distributor
    HOST="peer0.distributor.pharma-network.com"
    PORT=9051
    export HOST="peer0.distributor.pharma-network.com"
    export PORT=9051

  elif [ $ORG == "retailer" ]; then
    HOST="peer0.retailer.pharma-network.com"
    PORT=11051
    export HOST="peer0.retailer.pharma-network.com"
    export PORT=11051

  elif [ $ORG == "consumer" ]; then
    # consumer
    HOST="peer0.consumer.pharma-network.com"
    PORT=13051
    export HOST="peer0.consumer.pharma-network.com"
    export PORT=13051

  elif [ $ORG == "transporter" ]; then
    # transporter
    HOST="peer0.transporter.pharma-network.com"
    PORT=15051
    export HOST="peer0.transporter.pharma-network.com"
    export PORT=15051
      
  else
    echo "Org ${ORG} unknown"
  fi



  set -x
  # Modify the configuration to append the anchor peer 
  jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$HOST'","port": '$PORT'}]},"version": "0"}}' ${CORE_PEER_LOCALMSPID}config.json > ${CORE_PEER_LOCALMSPID}modified_config.json
  { set +x; } 2>/dev/null

  # Compute a config update, based on the differences between 
  # {orgmsp}config.json and {orgmsp}modified_config.json, write
  # it as a transaction to {orgmsp}anchors.tx
  createConfigUpdate ${CHANNEL_NAME} ${CORE_PEER_LOCALMSPID}config.json ${CORE_PEER_LOCALMSPID}modified_config.json ${CORE_PEER_LOCALMSPID}anchors.tx
}

updateAnchorPeer() {
  peer channel update -o orderer.pharma-network.com:7050 --ordererTLSHostnameOverride orderer.pharma-network.com -c $CHANNEL_NAME -f ${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile "$ORDERER_CA" >&log.txt
  res=$?
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  successln "Anchor peer set for org '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME'"
}

ORG=$1
CHANNEL_NAME=$2

setGlobalsCLI $ORG 0

createAnchorPeerUpdate 

updateAnchorPeer 
