// SPDX-License-Identifier: MIT

pragma solidity ^0.4.24;

import "./ERC20.sol";


contract NotLuna is ERC20{
    
    string public name = "NotLuna";
    string public symbol = "NL";

    uint public decimals = 10000;
    uint public totalSupply;

    address creator;

    struct Owner {
        address owner;
        uint balance;
        mapping(address => uint) approved;
    }

    mapping(address => Owner) balances;

    constructor(uint _totalSupply) public {
        creator = msg.sender;
        totalSupply = _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance){
        balance = balances[_owner].balance;
    }

    function transfer(address _to, uint _value) public returns(bool success) {
        require(_value <= balanceOf(msg.sender));
        balances[msg.sender].balance -= _value;
        balances[_to].balance += _value;

        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(balances[_from].approved[msg.sender] >= _value);
        require(balances[_from].balance >= _value);

        balances[_from].balance -= _value;
        balances[_to].balance += _value;

        balances[_from].approved[msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        success = true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        balances[msg.sender].approved[_spender] = _value;
        success = true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        remaining = balances[_owner].approved[_spender];
    }
}