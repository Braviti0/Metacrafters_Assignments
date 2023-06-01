// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract BankApp{
    mapping (address => uint256) UserAccount;
    mapping (address => bool) UserExists;

    function createAcc() public returns (bool) {
        require(UserExists[msg.sender] == false, "User already Exists");
        UserExists[msg.sender] = true;
        return true;
    }

    function accountExists() public view returns (bool){
        return UserExists[msg.sender];
    }

    function deposit() public payable {
        UserAccount[msg.sender] = UserAccount[msg.sender] + msg.value;
    }

    function withdraw(uint256 withdrawAmount) public payable {
        // Account should exist and Amount deposited should be greater than withdrawAmount
        require(UserExists[msg.sender] == true, "Account does not exist");
        require(withdrawAmount < UserAccount[msg.sender], "Balance is low");

        // Deduct the amount to be withdrawn from the User's balance
        UserAccount[msg.sender] = UserAccount[msg.sender] - withdrawAmount;

        // Now transfer that amount to the User's address
        bool sent = payable(msg.sender).send(withdrawAmount);
        require (sent, "transaction failed");
    }

    
    // Function (checks Account Balance in the contract for a given account (msg.sender) )
    function accountBalance() public view returns(uint256) {
        return UserAccount[msg.sender];
    }

    // Function (transfers ether to another User's (Account) address
    function transferEther(address payable reciever, uint256 transferAmount) public payable {
        // Both Accounts should exist and Amount deposited should be greater than withdrawAmount
        require(UserExists[msg.sender] == true, "Sender account does not exist");
        require(UserExists[msg.sender] == true, "Reciever account does not exist");
        require(transferAmount < UserAccount[msg.sender], "Balance is low");

        // Deduct the amount sent from the sender's balance
        UserAccount[msg.sender] = UserAccount[msg.sender] - transferAmount;

        // transfer that amount to the reciever's wallet
        bool sent =reciever.send(transferAmount);
        require (sent, "transaction failed");
        }
}