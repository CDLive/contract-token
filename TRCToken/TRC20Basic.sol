pragma solidity ^0.4.23;


/**
 * @title TRC20Basic
 * @dev Simpler version of TRC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract TRC20Basic {
  function totalSupply() public constant returns (uint);
  function balanceOf(address who) public constant returns (uint);
  function transfer(address to, uint value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint value);
}
