#!/bin/bash

function createSBIBank() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/sbibank.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/sbibank.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-sbibank --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbibank.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbibank.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbibank.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sbibank.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/sbibank.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-sbibank --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-sbibank --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-sbibank --id.name sbibankadmin --id.secret sbibankadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sbibank -M "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/msp" --csr.hosts peer0.sbibank.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sbibank -M "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls" --enrollment.profile tls --csr.hosts peer0.sbibank.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbibank.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbibank.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbibank.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/sbibank.example.com/tlsca/tlsca.sbibank.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/sbibank.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/peers/peer0.sbibank.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/sbibank.example.com/ca/ca.sbibank.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-sbibank -M "${PWD}/organizations/peerOrganizations/sbibank.example.com/users/User1@sbibank.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/sbibank.example.com/users/User1@sbibank.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://sbibankadmin:sbibankadminpw@localhost:7054 --caname ca-sbibank -M "${PWD}/organizations/peerOrganizations/sbibank.example.com/users/Admin@sbibank.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/sbibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/sbibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/sbibank.example.com/users/Admin@sbibank.example.com/msp/config.yaml"
}

function createICICIBank() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/icicibank.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/icicibank.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-icicibank --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icicibank.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icicibank.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icicibank.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-icicibank.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/icicibank.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-icicibank --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-icicibank --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-icicibank --id.name icicibankadmin --id.secret icicibankadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-icicibank -M "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/msp" --csr.hosts peer0.icicibank.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-icicibank -M "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls" --enrollment.profile tls --csr.hosts peer0.icicibank.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/icicibank.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/icicibank.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/icicibank.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/icicibank.example.com/tlsca/tlsca.icicibank.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/icicibank.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/peers/peer0.icicibank.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/icicibank.example.com/ca/ca.icicibank.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-icicibank -M "${PWD}/organizations/peerOrganizations/icicibank.example.com/users/User1@icicibank.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/icicibank.example.com/users/User1@icicibank.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://icicibankadmin:icicibankadminpw@localhost:8054 --caname ca-icicibank -M "${PWD}/organizations/peerOrganizations/icicibank.example.com/users/Admin@icicibank.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/icicibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/icicibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/icicibank.example.com/users/Admin@icicibank.example.com/msp/config.yaml"
}

function createCITIBank() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/citibank.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/citibank.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-citibank --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-citibank.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-citibank.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-citibank.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-citibank.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/citibank.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-citibank --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-citibank --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-citibank --id.name citibankadmin --id.secret citibankadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-citibank -M "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/msp" --csr.hosts peer0.citibank.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-citibank -M "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls" --enrollment.profile tls --csr.hosts peer0.citibank.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/citibank.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/citibank.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/citibank.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/citibank.example.com/tlsca/tlsca.citibank.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/citibank.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/peers/peer0.citibank.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/citibank.example.com/ca/ca.citibank.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-citibank -M "${PWD}/organizations/peerOrganizations/citibank.example.com/users/User1@citibank.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/citibank.example.com/users/User1@citibank.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://citibankadmin:citibankadminpw@localhost:11054 --caname ca-citibank -M "${PWD}/organizations/peerOrganizations/citibank.example.com/users/Admin@citibank.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/citibank/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/citibank.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/citibank.example.com/users/Admin@citibank.example.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp" --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls" --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
