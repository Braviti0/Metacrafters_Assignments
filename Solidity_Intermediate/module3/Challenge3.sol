// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// This contract demonstrates instances of the view and pure functions
contract Display {
    uint contract_id;

    // Constructor (sets the contract_id variable during contract deployment)
    constructor (uint x){
        contract_id = x;
    }

    // view function (reads the contract_id variable)
    function Check_id() public view returns (uint) {
        return contract_id;
    }

    // pure function (doubles up function input)
    function doubleUp(uint y) public pure returns (uint) {
        return 2*y;
    }
}