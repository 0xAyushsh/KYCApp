package main

import (
	"simple-kyc-application-chaincode/contracts"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {
	kycContract := new(contracts.KYCContract)

	cc, err := contractapi.NewChaincode(kycContract)

	if err != nil {
		panic(err.Error())
	}

	if err := cc.Start(); err != nil {
		panic(err.Error())
	}
}
