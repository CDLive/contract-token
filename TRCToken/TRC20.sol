pragma solidity ^0.4.23;

import "./TRC20Basic.sol";


/**
 * @title TRC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract TRC20 is TRC20Basic {
  function allowance(address owner, address spender) public constant returns (uint);
  function transferFrom(address from, address to, uint value) public returns (bool);
  function approve(address spender, uint value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint value);
}

