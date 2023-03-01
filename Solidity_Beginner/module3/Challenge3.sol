// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Calculator {
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
    
    function subtract(uint a, uint b) public pure returns (uint) {
        require(b <= a, "b must be less than or equal to a");
        return a - b;
    }
    
    function multiply(uint a, uint b) public pure returns (uint) {
        return a * b;
    }
    
    function divide(uint a, uint b) public pure returns (uint) {
        require(b > 0, "b cannot be zero");
        return a / b;
    }
}
