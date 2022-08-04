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
        -e "s/\${ORGMSP}/$6/" \
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
        -e "s/\${ORGMSP}/$6/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=sbibank
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/sbibank.example.com/tlsca/tlsca.sbibank.example.com-cert.pem
CAPEM=organizations/peerOrganizations/sbibank.example.com/ca/ca.sbibank.example.com-cert.pem
ORGMSP=SBIBankMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sbibank.example.com/connection-sbibank.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sbibank.example.com/connection-sbibank.yaml

ORG=icicibank
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/icicibank.example.com/tlsca/tlsca.icicibank.example.com-cert.pem
CAPEM=organizations/peerOrganizations/icicibank.example.com/ca/ca.icicibank.example.com-cert.pem
ORGMSP=ICICIBankMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/icicibank.example.com/connection-icicibank.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/icicibank.example.com/connection-icicibank.yaml

ORG=citibank
P0PORT=11051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/citibank.example.com/tlsca/tlsca.citibank.example.com-cert.pem
CAPEM=organizations/peerOrganizations/citibank.example.com/ca/ca.citibank.example.com-cert.pem
ORGMSP=CITIBankMSP

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/citibank.example.com/connection-citibank.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/citibank.example.com/connection-citibank.yaml
