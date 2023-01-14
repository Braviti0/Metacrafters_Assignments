// SPDX-License-Identifier: MIT

// This Challenge consists of two contracts:
// -a parent contract that demonstrates the view, pure and payable functions
// -a child contract that can access these functions demonstrating the function visibility

pragma solidity ^0.8.13;


contract SavingsWallet {
    
    // Declaration of owner address marked as payable (can send and recieve ether from contract)
    address payable public owner;

    // Constructor function (sets the owner address during contract deployment)
    constructor() payable{
        owner = payable(msg.sender);
    }

    // modifier (makes sure only the owner can access a given function)
    modifier onlyOwner { 
        require (owner == msg.sender, "only owner can access");
        _;
    }

    // View function (checks the balance of the contract)
    // Promise not to modify the state.
    function Balance() internal view returns (uint) {
        return address(this).balance;
    }
    
    // Payable function (recieves ether into contract address)
    // Cannot be called by child contracts
    function Deposit () external payable {}

    // Pure function (adds two numbers)
    // Promise not to modify or read from the state.
    function Add(uint i, uint j) internal pure returns (uint) {
        return i + j;
    }

    // Payable function (sends ether from contract to owner address)
    // Can be called by child contracts
    function Withdraw () public payable onlyOwner {
        bool sent = owner.send(address(this).balance);
        require(sent, "balance is null");
    }

}

contract SavingsWalletInterface is SavingsWallet {

    // Demonstrates use of view contract by a child contract
    function getBalance () public view returns (uint) {
        uint contractBalance = Balance();
        return contractBalance;
    }

    // Demonstrates use of pure contract by a child contract
    function Addnumbers (uint _i, uint _j) public pure returns (uint) {
        return Add(_i, _j);
    }

    // Demonstrates use of payable contract by a child contract
    function transferEthers () public payable {
        Withdraw();
    }

}
