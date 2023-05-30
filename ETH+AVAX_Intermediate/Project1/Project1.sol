// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Counter {
    uint private num;
    address owner;


    function addCount() public {

        // require statement
        require(msg.sender == owner, "only owner can add count");

        uint tempNum = num;

        // state change
        num = num + 1;

        // assert statement (always true)
        assert(num == tempNum + 1);
    }

    function viewCounts() public view returns (uint) {
        if ( num == 0) {
            revert("no counts yet");
        }
        return num;
    }

    constructor () {
        owner = msg.sender;
        assert(owner == msg.sender);
    }

}
