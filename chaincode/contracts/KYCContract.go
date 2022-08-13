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

// CustomerDetail : The asset being tracked on the chain
type CustomerDetail struct {
	AadharNumber 	  string `json:"aadhar"` // 12 digits unique UID
	Name 	          string `json:"name"`
	DOB		          string `json:"dateOfBirth"` //Format DD-MM-YYYY
	BankName		  string `json:"bank"`
}

// CreateCustomerDetail creates a new customer kyc details and add it to the world state .
func (spc *KYCContract) CreateCustomerDetail(ctx contractapi.TransactionContextInterface, aadhar string, name string, dob string, bankname string) error {

	exists, err := spc.CustomerExists(ctx, aadhar)
    if err != nil {
      return err
    }
    if exists {
      return fmt.Errorf("the asset %s already exists", aadhar)
    }

    customer := CustomerDetail{
      AadharNumber:  aadhar,
      Name:          name,
      DOB:           dob,
      BankName:      bankname,
    }
	
    customerJSON, err := json.Marshal(customer)
    if err != nil {
      return err
    }
	
	err = ctx.GetStub().PutState(aadhar, customerJSON)
	if err != nil {
		return err
	}
    return nil
  }

// GetCustomerDetail returns the customer kyc detail stored in the world state with given aadhar number.
func (spc *KYCContract) GetCustomerDetail(ctx contractapi.TransactionContextInterface, aadhar string) (*CustomerDetail, error) {
  
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

  // UpdateAsset updates an existing customer kyc detail in the world state with provided parameters.
  func (spc *KYCContract) UpdateCustomerDetail(ctx contractapi.TransactionContextInterface, aadhar string, name string, dob string, bankName string) error {
	exists, err := spc.CustomerExists(ctx, aadhar)
	if err != nil {
	  return err
	}
	if !exists {
	  return fmt.Errorf("Customer with Aadhar number %s does not exist", aadhar)
	}

	// overwriting original kyc detail with new kyc detail
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

// CustomerExists returns true when customer detail with given AADHAR NUMBER exists in world state
func (spc *KYCContract) CustomerExists(ctx contractapi.TransactionContextInterface, aadhar string) (bool, error) {

	customerJSON, err := ctx.GetStub().GetState(aadhar)
	if err != nil {
	  return false, fmt.Errorf("failed to read from world state: %v", err)
	}
	return customerJSON != nil, nil
  }




