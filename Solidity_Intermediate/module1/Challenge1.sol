// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0; //solidity version

// Contract for a primitive token that is mintable and burnable but cannot be transferred
contract Mytoken{

    // Declaration of state variables (owner of tokens and contract) and totalSupply of tokens
    uint totalSupply;
    address owner;

    // Constructor sets the owner of the contract during deployment
    constructor(){
        owner = msg.sender;
    }

    // modifier (makes sure only the owner can access a given function)
    modifier onlyOwner { 
        require (owner == msg.sender, "only owner can access");
        _;
    }
    // All functions below can only be accessed by the owner

    // mint function (allows owner to add tokens)
    function mint (uint _amount) public onlyOwner{
        totalSupply = totalSupply + _amount;
    }

    // function balanceOf (allows owner to check the balance)
    function balanceOf() public view onlyOwner returns(uint){
        return totalSupply;
    }

    //function burn (allows owner to remove tokens)
    function burn (uint _amount) public onlyOwner {
        totalSupply = totalSupply - _amount;
    }
}
