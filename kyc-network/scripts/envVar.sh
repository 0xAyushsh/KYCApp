#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_SBIBank_CA=${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/ca.crt
export PEER0_ICICIBank_CA=${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/ca.crt
export PEER0_CITIBank_CA=${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/ca.crt
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="SBIBankMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SBIBank_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/sbibank.example.com/users/Admin@sbibank.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="ICICIBankMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ICICIBank_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/icicibank.example.com/users/Admin@icicibank.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="CITIBankMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CITIBank_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/citibank.example.com/users/Admin@citibank.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.sbibank.example.com:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.icicibank.example.com:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.citibank.example.com:11051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
# parsePeerConnectionParameters() {
#   PEER_CONN_PARMS=()
#   PEERS=""
#   while [ "$#" -gt 0 ]; do
#     setGlobals $1
#     PEER="peer0.org$1"
#     ## Set peer addresses
#     if [ -z "$PEERS" ]
#     then
# 	PEERS="$PEER"
#     else
# 	PEERS="$PEERS $PEER"
#     fi
#     PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
#     ## Set path to TLS certificate
#     CA=PEER0_ORG$1_CA
#     TLSINFO=(--tlsRootCertFiles "${!CA}")
#     PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
#     # shift by one to get to the next organization
#     shift
#   done
# }

parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    local USING_ORG=""
    if [ -z "$OVERRIDE_ORG" ]; then
      USING_ORG=$1
    else
      USING_ORG="${OVERRIDE_ORG}"
    fi
    
    if [ $USING_ORG -eq 1 ]; then
      PEER="peer0.sbibank"
      CA=PEER0_SBIBank_CA
    elif [ $USING_ORG -eq 2 ]; then
      PEER="peer0.icicibank"
      CA=PEER0_ICICIBank_CA
    elif [ $USING_ORG -eq 3 ]; then
      PEER="peer0.citibank"
      CA=PEER0_CITIBank_CA
    else
      errorln "ORG Unknown"
    fi 
    # PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	    PEERS="$PEER"
    else
	    PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    # CA=PEER0_ORG$1_CA
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
