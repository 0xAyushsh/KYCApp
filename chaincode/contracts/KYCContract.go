package contracts


import (
    "encoding/json"
	"fmt"
	"log"
    "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type KYCContract struct {
	contractapi.Contract
}

// CustomerKyc : The asset being tracked on the chain
type CustomerDetail struct {
	AadharNumber 	  string `json:"aadhar"` // 12 digits unique UID
	Name 	          string `json:"name"`
	DOB		          string `json:"dateOfBirth"` //Format DD-MM-YYYY
	BankName		  string `json:"bank"`
}

// CreateAsset issues a new asset to the world state with given details.
func (spc *KYCContract) CreateCustomerDetail(ctx contractapi.TransactionContextInterface, aadhar string, name string, dob string, bankname string) error {
	log.Println("step1")
	exists, err := spc.CustomerExists(ctx, aadhar)
    if err != nil {
      return err
    }
    if exists {
      return fmt.Errorf("the asset %s already exists", aadhar)
    }
	log.Println("creeating asset")
    customer := CustomerDetail{
      AadharNumber:  aadhar,
      Name:          name,
      DOB:           dob,
      BankName:      bankname,
    }
	log.Println("Marshalling asset")
    customerJSON, err := json.Marshal(customer)
    if err != nil {
      return err
    }
	log.Println("Putstate asset")
	err = ctx.GetStub().PutState(aadhar, customerJSON)
	if err != nil {
		return err
	}
    return nil
  }


// // Create a new User ( ORG pov )
// func (spc *KYCContract) RegisterKYC(ctx contractapi.TransactionContextInterface,  aadhar string, name string, dob string, bankName string)  error {
// 	log.Println("Invoked method")
// 	// checks to see if user already exists
// 	customerBytes, err := ctx.GetStub().GetState(aadhar)

// 	if err != nil {
// 		return fmt.Errorf("failed to read from world state: %v", err)
// 	}

// 	if customerBytes != nil {
// 		return fmt.Errorf("the account already exists for Aadhar number %s", aadhar)
// 	}
// 	log.Println("creating user")

// 	customer := CustomerDetail{
// 		AadharNumber: aadhar,
// 		Name: name,
// 		DOB: dob,
// 		BankName:bankName,
// 	}

// 	customerBytes, err = json.Marshal(customer)
// 	if err != nil {
// 		return err
// 	}

// 	log.Println("marshal user")

// 	err = ctx.GetStub().PutState(aadhar, customerBytes)
// 	if err != nil {
// 		return err

// 	}
// 	log.Println("Put State user")

// 	return nil
// }



// ReadAsset returns the asset stored in the world state with given id.
func (spc *KYCContract) GetCustomerDetail(ctx contractapi.TransactionContextInterface, aadhar string) (*CustomerDetail, error) {
    log.Println("TESTISADILASJDLAJSLDJASLKDJSAKLDJKLAS")
	customerJSON, err := ctx.GetStub().GetState(aadhar)
    if err != nil {
      return nil, fmt.Errorf("failed to read from world state: %v", err)
    }
    if customerJSON == nil {
      return nil, fmt.Errorf("the asset %s does not exist", aadhar)
    }

    var customer CustomerDetail
    err = json.Unmarshal(customerJSON, &customer)
    if err != nil {
      return nil, err
    }

    return &customer, nil
  }

  // UpdateAsset updates an existing asset in the world state with provided parameters.
  func (spc *KYCContract) UpdateCustomerDetail(ctx contractapi.TransactionContextInterface, aadhar string, name string, dob string, bankName string) error {
	exists, err := spc.CustomerExists(ctx, aadhar)
	if err != nil {
	  return err
	}
	if !exists {
	  return fmt.Errorf("Customer with Aadhar number %s does not exist", aadhar)
	}

	// overwriting original asset with new asset
	customer := CustomerDetail{
		AadharNumber: aadhar,
		Name: name,
		DOB: dob,
		BankName:bankName,
	}
	customerJSON, err := json.Marshal(customer)	
	if err != nil {
	  return err
	}

	return ctx.GetStub().PutState(aadhar, customerJSON)
}

// AssetExists returns true when asset with given ID exists in world state
func (spc *KYCContract) CustomerExists(ctx contractapi.TransactionContextInterface, aadhar string) (bool, error) {
	log.Println("inside customerexist")
	customerJSON, err := ctx.GetStub().GetState(aadhar)
	if err != nil {
	  return false, fmt.Errorf("failed to read from world state: %v", err)
	}
	log.Println("returning ")
	return customerJSON != nil, nil
  }




