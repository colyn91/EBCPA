package apklist

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing anonymous public key list
type SmartContract struct {
	contractapi.Contract
}

// Asset describes basic details of what makes up a simple asset
type APKList struct {
	Hash          string `json:"Hash"`
	APK1          string `json:"APK1"`
	APK2          string `json:"APK2"`
}

// Submit issues a new anonymous public key to the world state with given details.
func (s *SmartContract) Submit(ctx contractapi.TransactionContextInterface, hash string, apk1 string, apk2 string) error {

	// Only the caller has the "apklist.creator" attribute can invoke this algorithm;
	// otherwise, return an error.
	//
	err := ctx.GetClientIdentity().AssertAttributeValue("apklist.creator", "true")
	if err != nil {
		return fmt.Errorf("submitting client not authorized to create asset, does not have apklist.creator role")
	}

	exists, err := s.Check(ctx, hash)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("the asset %s already exists", hash)
	}

	apk := APKList{
		Hash:          hash,
		APK1:          apk1,
		APK2:          apk2,
	}
	apkJSON, err := json.Marshal(apk)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(hash, apkJSON)
}


// Revoke deletes a given anonymous public key from the world state.
func (s *SmartContract) Revoke(ctx contractapi.TransactionContextInterface, hash string) error {

	exists, err := s.Check(ctx, hash)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the asset %s dose not exist", hash)
	}

	err = ctx.GetClientIdentity().AssertAttributeValue("apklist.creator", "true")
	if err != nil {
		return fmt.Errorf("the client not authorized to delete apk, does not have apklist.creator role")
	}

	return ctx.GetStub().DelState(hash)
}

// Check returns true when apk1 and apk2 exist in world state
func (s *SmartContract) Check(ctx contractapi.TransactionContextInterface, hash string) (bool, error) {

	apkJSON, err := ctx.GetStub().GetState(hash)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return apkJSON != nil, nil
}

