// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleContract {

    // Declare state variables of different types
    uint myUint;         // unsigned integer (uint)
    bool myBool;         // boolean (bool)
    string myString;     // string (string)
    address myAddress;   // Ethereum address (address)

    // Define a function to set the value of the uint variable
    function setMyUint(uint _myUint) public returns (uint) {
        myUint = _myUint;   // Set the value of the state variable
        return myUint;      // Return the new value of the variable
    }
    
    // Define a function to get the value of the uint variable
    function getMyUint() public view returns (uint) {
        return myUint;      // Return the current value of the variable
    }
    
    // Define a function to set the value of the bool variable
    function setMyBool(bool _myBool) public returns (bool) {
        myBool = _myBool;   // Set the value of the state variable
        return myBool;      // Return the new value of the variable
    }
    
    // Define a function to get the value of the bool variable
    function getMyBool() public view returns (bool) {
        return myBool;      // Return the current value of the variable
    }
    
    // Define a function to set the value of the string variable
    function setMyString(string memory _myString) public returns (string memory) {
        myString = _myString;   // Set the value of the state variable
        return myString;        // Return the new value of the variable
    }
    
    // Define a function to get the value of the string variable
    function getMyString() public view returns (string memory) {
        return myString;        // Return the current value of the variable
    }
    
    // Define a function to set the value of the address variable
    function setMyAddress(address _myAddress) public returns (address) {
        myAddress = _myAddress; // Set the value of the state variable
        return myAddress;       // Return the new value of the variable
    }
    
    // Define a function to get the value of the address variable
    function getMyAddress() public view returns (address) {
        return myAddress;       // Return the current value of the variable
    }
}
