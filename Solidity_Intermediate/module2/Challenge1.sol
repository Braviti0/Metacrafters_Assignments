// This file contains solidity code demonstrating the use of storage and memory types

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract testStorage{
    struct contractInstance {
        uint16 contract_id;
        string contract_name;
    }
    // demonstrations of storage type
     contractInstance  myContract;
     uint16 contractState;

     // assigning values to the variables in storage location
     // the string datatype requires explicit declaration of it's location (memory)
    constructor(uint16 x, string memory y, uint16 z) {
        myContract.contract_id = x;
        myContract.contract_name = y;
        contractState = z;
    }

    // the struct datatype requires explicit declaration of it's location (memory or calldata)
    function viewInstance() public view returns (contractInstance memory) {
      return myContract;
    }

    function viewState() public view returns (uint16) {
      return contractState;
    }

    // demonstration of memory type
    // sumUp adds 2 numbers a and b and returns the result as c (memory type)
    function sumUp (uint32 a, uint32 b) public pure returns (uint32) {
        uint32 c = a + b;
        return c;
    }
    
    //demonstration of calldata type
    function changeInstance(uint16 x, string calldata y) public {
      myContract.contract_id = x;
      myContract.contract_name = y;
    }
    
    function changeState(uint16 a) public {
      contractState = a;
    }
}