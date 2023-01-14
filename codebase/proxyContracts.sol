// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// NOTE: Deploy this contract first
contract Twocalled {
    // NOTE: storage layout must be the same as contract oneCall
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract OneCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable returns (bool, bytes memory){
        // OneCall's storage is set, Twocall is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        return (success, data);
    }
}
