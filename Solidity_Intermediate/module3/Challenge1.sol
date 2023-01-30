// SPDX-License-Identifier: MIT

// Most of the code here is recycled from module1 Challenge2
// This Challenge consists of two contracts:
// -a contract that receives ether and stores it until the owner address requests a withdrawal
// -a contract that can access send ether to another contract address

pragma solidity ^0.8.13;

// Contract (recieves and stores ether until withdrawal request)
contract Wallet {
    
    // Declaration of owner address marked as payable (can send and recieve ether from contract)
    address payable public owner;

    // Declaration of event (can be used to create logs of function calls)
    event response (string);

    // Constructor function (sets the owner address during contract deployment)
    constructor() payable{
        owner = payable(msg.sender);
    }

    // modifier (makes sure only the owner can access a given function)
    modifier onlyOwner { 
        require (owner == msg.sender, "only owner can access");
        _;
    }

    // function (allows one to check the ether stored in the contract)
    function Balance() public view returns (uint) {
        return address(this).balance;
    }
    
    // fallback function (handles unrecognized calls)
    // emits a response to prove function was executed
    fallback () external payable {
        emit response ("fallback called");
    }

    // receive function (receives ether into contract address)
    // emits a response to prove function was executed
    receive () external payable {
        emit response ("ethers received");
    }

    // Payable function (sends ether from contract to owner address)
    function Withdraw () public payable onlyOwner {
        bool sent = owner.send(address(this).balance);
        require(sent, "balance is null");
        emit response ("ethers sent");
    }
}

// Contract (can send ether to another address or contract)
contract walletInterface {

    // event (logs transaction outcome and data)
    event response (bool, bytes);

    // Payable function (sends ether from contract to owner address)
    // Can be called by child contracts
    function sendEthers (address payable receipient) public payable{
        bool sent = receipient.send(msg.value);
        emit response(sent,"");
    }

    // Payable function (performs function call to a non-existent function in a given contract address)
    function callRandom (address payable receipient) public payable {
        (bool success, bytes memory data) = receipient.call{value: msg.value, gas: 2300}(
            abi.encodeWithSignature("Random()")
        );
        emit response (success, data);
    }
}
