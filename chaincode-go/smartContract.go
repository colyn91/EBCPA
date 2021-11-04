/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"log"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	apklist "github.com/colyn91/EBCPA/tree/main/chaincode-go/smart-contract"
)

func main() {
	apklistSmartContract, err := contractapi.NewChaincode(&apklist.SmartContract{})
	if err != nil {
		log.Panicf("Error creating apklist chaincode: %v", err)
	}

	if err := apklistSmartContract.Start(); err != nil {
		log.Panicf("Error starting apklist chaincode: %v", err)
	}
}
