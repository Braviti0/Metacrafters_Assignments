// The contracts in this challenge function as investment wallets for the address owner
// The owner can deposit money into different contracts
// Contracts are switched using delegatecall() managed by a proxy contract

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract proxyContract {

    // Declaration of owner address marked as payable (can send and recieve ether from contract)
    address payable public owner;
    address[] public contracts;

    // Constructor function (sets the owner address during contract deployment)
    constructor () payable{
        owner = payable(msg.sender);
    }

    // modifier (makes sure only the owner can access a given function)
    modifier onlyOwner { 
        require (owner == msg.sender, "only owner can access");
        _;
    }
    
    // modifier (makes sure a given contract index is in the contracts array)
    modifier existingIndex(uint32 index) { 
        require (index < contracts.length, "contract does not exist");
        _;
    }

    // generic function (checks if an address is within a given address array)
    function checkAddress(address value, address[] memory iterable) public pure returns (bool x, uint32 y) {
        for (uint32 i = 0; i < iterable.length; i++) {
                if (iterable[i] == value) {
                    return(true, i);
            } 
        }
        return(false, 0);
    }

    // function (adds a contract address to the contracts array)
    function addContract(address x) public onlyOwner {
        contracts.push(x);
    }

    // function (deprecates an existing contract)
    function deprecate(address x) public onlyOwner {
        (bool exists, uint32 index) = checkAddress(x, contracts);
        require (exists, "contract does not exist in the list");
        contracts[index] = contracts[contracts.length - 1];
        contracts.pop;
    }

    // function (returns an array of all contract addresses)
    function viewContracts() public view onlyOwner returns (address[] memory) {
        return contracts;
    }

    // function (checks contract balance for given contract index)
    function Balance(uint32 index) public onlyOwner returns (bool, bytes memory) {
        (bool success, bytes memory data) = contracts[index].delegatecall(abi.encodeWithSignature("Balance()") );
        require(success, "secondary contract operation failed");
        return (success, data);
    }

    // function (Deposits ether into given contract index)
    function Deposit(uint32 index) public payable onlyOwner returns (bool, bytes memory) {
        (bool success, bytes memory data) = contracts[index].delegatecall(abi.encodeWithSignature("Deposit()") );
        require(success, "secondary contract operation failed");
        return (success, data);
    }


    function Withdraw(uint32 index, uint256 amount) public payable onlyOwner returns (bool, bytes memory) {
        (bool success, bytes memory data) = contracts[index].delegatecall(abi.encodeWithSignature("Withdraw(uint256)", amount) );
        require(success, "secondary contract operation failed");
        return (success, data);
    }

    function Send(uint32 index, address receipient, uint256 amount) public payable onlyOwner returns (bool, bytes memory) {
        (bool success, bytes memory data) = contracts[index].delegatecall(abi.encodeWithSignature("Send(address,uint256)", receipient, amount));
        require(success, "secondary contract operation failed");
        return (success, data);
    }
}

contract investment0 {
    
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
    function Balance() internal view onlyOwner returns (uint) {
        return address(this).balance;
    }

    // Payable function (recieves ether into contract address)
    function Deposit () external payable {}
    
    // Payable function (sends ether from contract to owner address)
    function Withdraw (uint256 amount) public payable onlyOwner {
        bool sent = owner.send(amount);
        require(sent, "balance is low");
    }

    // Send ether from investment contract to another person
    function Send (address payable receipient, uint256 amount) public payable onlyOwner {
        bool sent = receipient.send(amount);
        require(sent, "balance is low");
    }
}

contract investment1 {
    
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
    function Balance() internal view  onlyOwner returns (uint) {
        return address(this).balance;
    }
    
    // Payable function (recieves ether into contract address)
    // Cannot be called by child contracts
    function Deposit () external payable {}

    // Payable function (sends ether from contract to owner address)
    // Can be called by child contracts
    function Withdraw (uint256 amount) public payable onlyOwner {
        bool sent = owner.send(amount);
        require(sent, "balance is low");
    }

    // Send ether from investment contract to another person
    function Send (address payable receipient, uint256 amount) public payable onlyOwner {
        bool sent = receipient.send(amount);
        require(sent, "balance is low");
    }
}