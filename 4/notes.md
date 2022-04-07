# 4. Telephone

## Key:

> tx.origin (address): sender of the transaction (full call chain)

> msg.sender (address): sender of the message (current call)
> https://docs.soliditylang.org/en/v0.8.12/units-and-global-variables.html?highlight=tx.origin

> Never use tx.origin for authorization. https://docs.soliditylang.org/en/v0.8.12/security-considerations.html?highlight=tx.origin#tx-origin

> tx.origin is a global variable in Solidity which returns the address of the account that sent the transaction. Using the variable for authorization could make a contract vulnerable if an authorized account calls into a malicious contract. A call could be made to the vulnerable contract that passes the authorization check since tx.origin returns the original sender of the transaction which in this case is the authorized account.
> https://swcregistry.io/docs/SWC-115#:~:text=Description-,tx.,calls%20into%20a%20malicious%20contract.

## Solution

### Strategy

```js
player -> AttackerContract -> victimContract.changeOwner()

tx.origin == player
msg.sender == AttackerContract
```

### Step by step

1. Use Remix to deploy Telephone.sol
2. Code and deploy TelephoneAttack.sol contract invoquing the victim's contract address
3. Make a call from player addr to a function in Attacker contract => (tx.origin == player)
4. On that Attacker contract invoque changeOwner() from victim's contract => (msg.sender == Attacker contract's address).

## Post solution info

While this example may be simple, confusing tx.origin with msg.sender can lead to phishing-style attacks, such as this.

An example of a possible attack is outlined below.

Use `tx.origin` to determine whose tokens to transfer, e.g.

```js
function transfer(address _to, uint _value) {
  tokens[tx.origin] -= _value;
  tokens[_to] += _value;
}
```

Attacker gets victim to send funds to a malicious contract that calls the transfer function of the token contract, e.g.

```js
function () payable {
  token.transfer(attackerAddress, 10000);
}
```

In this scenario, `tx.origin` will be the victim's address (while `msg.sender` will be the malicious contract's address), resulting in the funds being transferred from the victim to the attacker.
