# Elevator

## Key

**Function visibility specifiers**:

`external` -> only visible externally.

**Modifiers**:

`(none present)`: allows access of state and modifying of state
`pure`: disallows moficiation and access of state
`view`: disallows modification of state, but allows access of state. (Cant change the state of the blockchain, this wont be vulnerable in this case)
...
https://docs.soliditylang.org/en/v0.7.0/cheatsheet.html#function-visibility-specifiers

**The function `isLastFloor()` have an `external` and a default modifier, so we can modify the logic of the intercae method. And change its returned value can be modified from the attacker's contract.**

```js
interface Building {
  function isLastFloor(uint) external returns (bool);
```

## Solution

1. Create a contract that implements the method `isLastFloor()` and changes its logic for it to return `false` and then `true`, to force the code flow to the necesary line.
2. Call our method `setTop()` with any number. That would do the magic needed to get to the floor.

## Post solution info

You can use the `view` function modifier on an interface in order to prevent state modifications. The `pure` modifier also prevents functions from modifying the state. Make sure you read [Solidity's documentation](http://solidity.readthedocs.io/en/develop/contracts.html#view-functions) and learn its caveats.

An alternative way to solve this level is to build a view function which returns different results depends on input data but don't modify state, e.g. `gasleft()`.
