#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${P1PORT}#$6#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${P1PORT}#$6#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

#manufacturer
ORG=manufacturer
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/manufacturer.pharma-network.com/tlsca/tlsca.manufacturer.pharma-network.com-cert.pem
CAPEM=organizations/peerOrganizations/manufacturer.pharma-network.com/ca/ca.manufacturer.pharma-network.com-cert.pem
P1PORT=8051

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/manufacturer.pharma-network.com/connection-manufacturer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/manufacturer.pharma-network.com/connection-manufacturer.yaml

#distributor
ORG=distributor
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/distributor.pharma-network.com/tlsca/tlsca.distributor.pharma-network.com-cert.pem
CAPEM=organizations/peerOrganizations/distributor.pharma-network.com/ca/ca.distributor.pharma-network.com-cert.pem
P1PORT=10051

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/distributor.pharma-network.com/connection-distributor.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/distributor.pharma-network.com/connection-distributor.yaml

#retailer
ORG=retailer
P0PORT=11051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/retailer.pharma-network.com/tlsca/tlsca.retailer.pharma-network.com-cert.pem
CAPEM=organizations/peerOrganizations/retailer.pharma-network.com/ca/ca.retailer.pharma-network.com-cert.pem
P1PORT=12051

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/retailer.pharma-network.com/connection-retailer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/retailer.pharma-network.com/connection-retailer.yaml

#consumer
ORG=consumer
P0PORT=13051
CAPORT=10054
PEERPEM=organizations/peerOrganizations/consumer.pharma-network.com/tlsca/tlsca.consumer.pharma-network.com-cert.pem
CAPEM=organizations/peerOrganizations/consumer.pharma-network.com/ca/ca.consumer.pharma-network.com-cert.pem
P1PORT=14051

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/consumer.pharma-network.com/connection-consumer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/consumer.pharma-network.com/connection-consumer.yaml

#transporter
ORG=transporter
P0PORT=15051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/transporter.pharma-network.com/tlsca/tlsca.transporter.pharma-network.com-cert.pem
CAPEM=organizations/peerOrganizations/transporter.pharma-network.com/ca/ca.transporter.pharma-network.com-cert.pem
P1PORT=16051

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/transporter.pharma-network.com/connection-transporter.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT)" > organizations/peerOrganizations/transporter.pharma-network.com/connection-transporter.yaml
