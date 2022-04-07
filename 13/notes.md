# Gatekeeper one

> Cannot resolved becuase SafeMath need compiler version 0.8.3. But the code challenge says 0.6.0 version. Different Solidity compiler versions will calculate gas differently. And whether or not optimization is enabled will also affect gas usage. And couldn't access the source code of the instanciated contract to check version.

## Key

`gasleft() returns (uint256): remaining gas`
https://docs.soliditylang.org/en/v0.8.3/units-and-global-variables.html

We have to archive three conditions

### `gateOne`

`require(msg.sender != tx.origin);`
Similar to `Telephone` challenge. We can archive calling from our account a function in an attacker's contracts that invoques the victims contract.

```js
player -> AttackerContract -> victimContract.changeOwner()

tx.origin == player
msg.sender == AttackerContract
```

### `gateTwo`

```js
require(gasleft().mod(8191) == 0);
```

`Tx`
|-> gas ~ gas limit sent in Tx
|-> Tx cost ~ gas spent in: Tx cost + execution cost
|-> Execution cost

We need to debug calling `enter` to add padding as gas for the condition to be met.

### `gateThree`

Casting to a uint256, but would casting into a uint32 take the most significant 32 bits or the least significant 32 bits

```
binary
8 bytes
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX

1 hex -> 4 bits. 2 hex -> 8 bits -> 1 byte
4 bytes    4 bytes
0x61626364 00000000 00000000 00000000 00000000 00000000 00000000 00000000
32 bytes

uint16 -> 16 bits -> 2 bytes -> 0x6162
uint32 -> 32 bits -> 4 bytes -> 0x61626364
uint64 -> 64 bits -> 8 bytes -> 0x61626364 0x61626364
uint160 -> 160bits -> 20bytes -> address in ethereum
                                0x4545c437 0xd127B29b F0BB080D eEe97f15 9AB827d8
uint256-> 256bits -> 32 bytes-> 0x61626364 0x61626364 61626364 61626364
                                  61626364 0x61626364 61626364 61626364




1. uint64 == bytes8 _gateKey
                                      (tx.origin)
                            0xXXXXXXXX YYYYYYYY
2. uint16 == 2 bytes        0x-------- ----YYYY
3. uint32 == 4 bytes        0x-------- 0000YYYY
4. !=uint64 == 8 bytes      0xXXXXXXXX 0000YYYY
5. MASK                     0xffffffff 0000ffff
-> byte8(tx.origin) & 0xffffffff0000ffff

```

### Side note

To use SafeMath library from openzepellin we need 0.8.0 compiler version and there are some new restrictions on type conversions. Please refer to:

> address(uint) and uint(address): converting both type-category and width. Replace this by address(uint160(uint)) and uint(uint160(address)) respectively.
> https://docs.soliditylang.org/en/v0.8.13/080-breaking-changes.html#new-restrictions

address(victim).call.gas(9000)(abi.encodeWithSignature("enter(bytes8)", key))
