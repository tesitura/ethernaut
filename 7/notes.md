# Force

## Key:

**Selfdestruct method**

> The selfdestruct(address) function removes all bytecode from the contract address and sends all ether stored to the specified address. If this specified address is also a contract, no functions (including the fallback) get called.
> In other words, an attacker can create a contract with a selfdestruct() function, send ether to it, call selfdestruct(target) and force ether to be sent to a target.
> https://hackernoon.com/how-to-hack-smart-contracts-self-destruct-and-solidity

## Solution

1. Create Attacker contract with 1 wei thanks to `constructor() public payable`
2. Check balance on victim contract

```
await getBalance(contract.address)
```

3. Execute a selfdestruct over victim's contract

## Post solution info

In solidity, for a contract to be able to receive ether, the fallback function must be marked payable.

However, there is no way to stop an attacker from sending ether to a contract by self destroying. Hence, it is important not to count on the invariant address(this).balance == 0 for any contract logic.
