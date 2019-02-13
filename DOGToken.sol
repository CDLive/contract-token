/**
 * DOG Token
 */

pragma solidity ^0.4.18;

import "./TRCToken/UpgradeableToken.sol";
import "./TRCToken/ReleasableToken.sol";
import "./TRCToken/PausableToken.sol";
import "./TRCToken/FreezableToken.sol";
import "./TRCToken/BurnableToken.sol";
import "./TRCToken/SafeMath.sol";

/**
 *  DOG Token.
 *
 * Token supply is created in the token contract creation and allocated to owner.
 * The owner can then transfer from its supply to crowdsale participants.
 *
 */
contract DOGToken is UpgradeableToken, ReleasableToken, PausableToken, BurnableToken, FreezableToken {

  string public name;
  string public symbol;
  uint8 public decimals;

  constructor(address _owner, string _name, string _symbol, uint256 _totalSupply, uint8 _decimals)  UpgradeableToken(_owner) public {
    name = _name;
    symbol = _symbol;
    totalSupply_ = _totalSupply;
    decimals = _decimals;

    // Allocate initial balance to the owner
    balances[_owner] = _totalSupply;
  }
}
