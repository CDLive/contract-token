pragma solidity ^0.4.23;

import './StandardToken.sol';
import './Pausable.sol';

/**
 * Pausable token
 *
 * Simple TRC20 Token example, with pausable token creation
 **/

contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint _value) whenNotPaused public returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }
}
