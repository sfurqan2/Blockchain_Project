// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

import "./IERC20.sol";

contract NotLuna is IERC20{
    
    bytes32 public name = "NotLuna";
    bytes32 public symbol = "NL";

    uint public decimals = 10000;
    uint public override totalSupply = 10000;

    address creator;

    struct Owner {
        address owner;
        uint balance;
        mapping(address => uint) approved;
    }

    mapping(address => Owner) balances;

    constructor() {
        creator = msg.sender;
    }

    // modifier to check for creator
    modifier onlyCreator(address _creator){
        require(_creator == creator);
        _;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance){
        balance = balances[_owner].balance;
    }

    function transfer(address _to, uint _value) public override returns(bool success) {
        require(_value <= balanceOf(msg.sender));
        
        balances[msg.sender].balance -= _value;
        balances[_to].balance += _value;

        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(balances[_from].approved[msg.sender] >= _value);
        require(balances[_from].balance >= _value);

        balances[_from].balance -= _value;
        balances[_to].balance += _value;

        balances[_from].approved[msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        success = true;
    }

    function approve(address _spender, uint256 _value) public override returns (bool success){
        balances[msg.sender].approved[_spender] = _value;
        success = true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining){
        remaining = balances[_owner].approved[_spender];
    }
}