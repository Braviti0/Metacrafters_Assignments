// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// This contracts demonstrates the use of global functions for msg type (msg.sender, msg.value)
// msg.gasleft didn't work so I used gasleft()
contract counter {
    uint i;
    address payable owner;

    // The constructor initializes i to user-defined value and sets the owner address to the address responsible for contract deployment
    // usage of the msg.sender function
    constructor(uint x) {
        if (x > 0) {
            i = x;
        }
        if (x < 0) {
            i = x;
        } else {
            i = 0;
        }
        owner = payable(msg.sender);
    }
    // modifier that makes sure the caller of a function is the owner
    //usage of the msg.sender function
    modifier onlyOwner { 
        require (owner == msg.sender, "only owner can access");
        _;
    }

    // function that changes the state variable i under two conditions:
    // if the owner calls the function
    // and if another address pays a sufficient fee to change i
    // usage of msg.value is used here
    // usage of gasleft is used here
    function change_i (uint _i) public payable returns (uint y) {
        if (msg.sender == owner) {
            i = _i;
        } else {
        require (msg.value > 300000, "the minimum fee for changing i was not sent ");
        i = _i;
        }
        return gasleft();
    }

    function withdraw () public payable onlyOwner {
    bool x = owner.send(address(this).balance);
    require (x, "contract address empty");
    }

    function check_i () public view returns (uint z) {
        return i;
    }
}