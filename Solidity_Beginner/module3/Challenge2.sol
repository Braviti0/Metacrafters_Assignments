// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EtherValue {

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

    // Payable function (accepts ether from user)
    function Deposit() payable public returns (uint inWei, uint inGwei, uint inEther) {
        inWei = msg.value; // returns value of ether sent in Wei
        inGwei = msg.value / 1 gwei; // returns value of ether sent in Gwei
        inEther = msg.value / 1 ether; // returns value of ether sent in Ether
    }

    // function (allows one to check the ether stored in the contract)
    function Balance() public view returns (uint) {
        return address(this).balance;
    }

    // Payable function (sends ether from contract to owner address)
    function Withdraw () public payable onlyOwner {
        bool sent = owner.send(address(this).balance); // sends the ether to the owner address
        require(sent, "balance is null"); // if the transaction fails, it reverts with an error message
        emit response ("ethers sent"); // emits an event with a message indicating that ethers were sent
    }

}
