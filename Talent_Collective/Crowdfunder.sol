// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Crowdfunder {

    // Declare State variables
    // An array containing a list of active crowdfunding campaigns
    /* A struct campaign containing
        The campaign's name
        The campaign's id
        The campaign's approved token
        The campaign's owner
        The campaign's start block_id (or block time)
        The campaign's end block_id (or block time)
    */
    // An integer which stores the next campaign Id

    struct campaign {
        uint id;
        string name;
        address owner;
        address token;
        uint duration;
        uint startTime;
    }

    uint[] activeCampaigns;
    mapping (uint => campaign) campaigns;
    uint nextId;

    // The constructor sets the first campaign id during contract deployment
    constructor (uint _firstId) {
        nextId = _firstId;
    }

    // Generic function returns 
    function Deposit(address _token) public view returns (uint) {

    }

    // function (returns )

}