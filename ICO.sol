// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

import "./MyERC20.sol";

contract InitialCoinOffering is NotLuna{
    uint public supply = 5000;
    uint public startBlock;
    uint public endBlock;
    uint public unitPrice = 0.001 ether;
    bool public open = true;

    constructor(){
        startBlock = block.timestamp;
        endBlock = block.timestamp + 2 weeks;
    }
    
    function buyToken(uint _value) public payable returns (bool success) {
        require(open);
        require(supply >= _value);
        require(balances[msg.sender].balance + _value <= 500);
        require(_value * unitPrice <= msg.value);

        // Lowering supply for ICO and increasing balance for owner

        supply -= _value;
        balances[msg.sender].balance += _value;

        // Returning the change to the owner
        payable(msg.sender).transfer(msg.value - (_value * unitPrice));

        success = true;
    }

    function closeOffering() public onlyCreator(msg.sender){
        open = false;
    }
}