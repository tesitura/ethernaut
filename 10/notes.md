# Re-entrancy

## Key

`call()`
Don't make control flow assumptions after external calls as for ex. using raw calls (of the form `someAddress.call()`). One particular danger is malicious code may hijack the control flow: If you are making a call to an untrusted external contract, avoid state changes after the call.

`send(), transfer(), and call.value()()`

- `someAddress.send()` and `someAddress.transfer()` are considered safe against reentrancy. While these methods still trigger code execution, the called contract is only given a stipend of 2,300 gas which is currently only enough to log an event.
- `x.transfer(y)` is equivalent to `require(x.send(y));`, it will automatically revert if the send fails.
- `someAddress.call.value(y)()` will send the provided ether and trigger code execution.
  The executed code is given all available gas for execution making this type of value transfer unsafe against reentrancy.
  https://ethereum-contract-security-techniques-and-tips.readthedocs.io/en/latest/recommendations/

**Reentrancy**:
A reentrancy attack occurs when a function makes an external call to another untrusted contract. Then the untrusted contract makes a recursive call back to the original function in an attempt to drain funds. When the contract fails to update its state before sending funds, the attacker can continuously call the withdraw function to drain the contract’s funds.
https://hackernoon.com/hack-solidity-reentrancy-attack

## Solution

1.  Deploy attacking contract with some wei for gas fees (ex. 1000000000000000) & with target victims in constructors (see code)
2.  Done some wei via `donate()` (will be in the account address inside `balances`) (ex. 1000000000000000 wei)
3.  Call via `Transact` in Remix the fallback function `receive()` to withdraw the amount of `wei` previously donated. As this triggers the withdraw loop, the balance of the victims contract get reduced to 0 (from 0.001 eth to 0)

## Post solution info

In order to prevent re-entrancy attacks when moving funds out of your contract, use the [Checks-Effects-Interactions pattern](https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern) being aware that call will only return false without interrupting the execution flow. Solutions such as [ReentrancyGuard](https://docs.openzeppelin.com/contracts/2.x/api/utils#ReentrancyGuard) or [PullPayment](https://docs.openzeppelin.com/contracts/2.x/api/payment#PullPayment) can also be used.

transfer and send are no longer recommended solutions as they can potentially break contracts after the Istanbul hard fork [Source 1](https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/) [Source 2](https://forum.openzeppelin.com/t/reentrancy-after-istanbul/1742).

Always assume that the receiver of the funds you are sending can be another contract, not just a regular address. Hence, it can execute code in its payable fallback method and re-enter your contract, possibly messing up your state/logic.

Re-entrancy is a common attack. You should always be prepared for it!

**The DAO Hack**
The famous DAO hack used reentrancy to extract a huge amount of ether from the victim contract. See [15 lines of code that could have prevented TheDAO Hack](https://blog.openzeppelin.com/15-lines-of-code-that-could-have-prevented-thedao-hack-782499e00942).
