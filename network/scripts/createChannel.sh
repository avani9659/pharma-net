#!/bin/bash

# imports  
. scripts/envVar.sh
. scripts/utils.sh

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="pharmachannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}

: ${CONTAINER_CLI:="docker"}
: ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
infoln "Using ${CONTAINER_CLI} and ${CONTAINER_CLI_COMPOSE}"

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

createChannelGenesisBlock() {
	which configtxgen
	if [ "$?" -ne 0 ]; then
		fatalln "configtxgen tool not found."
	fi
	set -x
	configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
  verifyResult $res "Failed to generate channel configuration transaction..."
}


#   channel join --channelID=CHANNELID --config-block=CONFIG-BLOCK
#     Join an Ordering Service Node (OSN) to a channel. If the channel does not
#     yet exist, it will be created.
createChannel() {
	echo "Inside createChannel()====================>> "
	setGlobals "manufacturer" 0
	# Poll in case the raft leader is not set yet
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
		osnadmin channel join --channelID $CHANNEL_NAME --config-block ./channel-artifacts/${CHANNEL_NAME}.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >&log.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
  FABRIC_CFG_PATH=$PWD/../config/
  ORG=$1
  PEER_NUM=$2
  setGlobals $ORG $PEER_NUM

	local rc=1
	local COUNTER=1
	## Sometimes Join takes time, hence retry
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer$PEER_NUM.$ORG has failed to join channel '$CHANNEL_NAME' "
}


FABRIC_CFG_PATH=${PWD}/configtx

ORGS=("manufacturer" "distributor" "retailer" "consumer" "transporter")

# Make peers from all the the organizations join the channel.
# To add more organizations to the network, add it 'ORGS' array above, and to add more peers to organizations,
# update nested for loop to include other peers.
joinChannelForAllPeer() {	
	for org in "${ORGS[@]}"; do
		for peer in 0 1; do
			echo "Joining peer$peer of $org to $CHANNEL_NAME channel..."
			joinChannel $org $peer
		done
	done
}

setAnchorPeer() {
  ORG=$1
  PEER_NUM=$2
  ${CONTAINER_CLI} exec cli ./scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME 
}

FABRIC_CFG_PATH=${PWD}/configtx

## Create channel genesis block
infoln "Generating channel genesis block '${CHANNEL_NAME}.block'"
createChannelGenesisBlock

BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

## Create channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

## Join all the peers to the channel
joinChannelForAllPeer
      
ORGS=("manufacturer" "distributor" "retailer" "consumer" "transporter")

## Set anchor peers for all the organizations

# Here, we are setting peer 0 of each organization as an anchor peer.
setAnchorPeerToAllPeers() {
	for org in "${ORGS[@]}"; do
		setGlobals $org 0
		infoln "Setting anchor peer for ${org}..."
		setAnchorPeer $org 0
	done
}

setAnchorPeerToAllPeers

successln "Channel '$CHANNEL_NAME' joined"
      