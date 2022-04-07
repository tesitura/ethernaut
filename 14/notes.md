# GatekeeperTwo

## Task

- Remember what you've learned from getting past the first gatekeeper - the first gate is the same.
- The `assembly` keyword in the second gate allows a contract to access functionality that is not native to vanilla Solidity. See [here](http://solidity.readthedocs.io/en/v0.4.23/assembly.html) for more information. The `extcodesize` call in this gate will get the size of a contract's code at a given address - you can learn more about how and when this is set in section 7 of the [yellow paper](https://ethereum.github.io/yellowpaper/paper.pdf).
- The `^` character in the third gate is a bitwise operation (XOR), and is used here to apply another common bitwise operation (see [here](http://solidity.readthedocs.io/en/v0.4.23/miscellaneous.html#cheatsheet)). The Coin Flip level is also a good place to start when approaching this challenge.

## Key

### `gateOne`

`require(msg.sender != tx.origin);`
Similar to `Telephone` challenge. We can archive calling from our account a function in an attacker's contracts that invoques the victims contract.

```js
player -> AttackerContract -> victimContract

tx.origin == player (EOA)
msg.sender == AttackerContract
```

### `gateTwo`

`extcodesize` -> smart contract code size (the one that is calling the victim's contract).
The calling contract size must be 0 or empty.

> Do not use the EXTCODESIZE check to prevent smart contracts from calling a function. This is not foolproof, it can be subverted by a constructor call, due to the fact that while the constructor is running, EXTCODESIZE for that address returns 0.
> https://stackoverflow.com/questions/37644395/how-to-find-out-if-an-ethereum-address-is-a-contract

**We need to call every victim's functionality within the constructor of our attacker contract.**

### `gateThree`

| A   | B   | XOR |
| --- | --- | --- |
| 0   | 0   | 0   |
| 0   | 1   | 1   |
| 1   | 0   | 1   |
| 1   | 1   | 0   |

```
A ^ B  == 11111....
XORing A with its bitwise negated value ~A will always returns 1 as a result.
A ^ ~A == 11111....

To get ~A => we need to XOR A with 0xfff... or 111111 => or A ^ uint64(0) - 1

uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);

uint64(0) - 1 => 0Xffffff... => 111111111...
```

For an XOR to result in all 1s the two Xored numbers must be complement of each other. `A ^ !A == 11111`

## Solution

1. Get the victim's contract address

```js
> contract.address
"0x2158475e42B0f0886563D826c48Ad6eeC90E51C5"
```

2. Instanciate the attacker contracts with victim's address in its constructor.
3. Verify we are the new entrant

```js
> contract.entrant()
0x4545c437d127B29bF0BB080DeEe97f159AB827d8
```

## Info after solution

Way to go! Now that you can get past the gatekeeper, you have what it takes to join [theCyber](https://etherscan.io/address/thecyber.eth#code), a decentralized club on the Ethereum mainnet. Get a passphrase by contacting the creator on [reddit](https://www.reddit.com/user/0age) or via [email](mailto:0age@protonmail.com) and use it to register with the contract at [gatekeepertwo.thecyber.eth](https://etherscan.io/address/gatekeepertwo.thecyber.eth#code) (be aware that only the first 128 entrants will be accepted by the contract).
