pragma solidity ^0.4.23;

import "./StandardToken.sol";
import "./SafeMath.sol";
import "./Ownable.sol";


/**
 * @title Freezable Token
 * @dev Token that can be freezed.
 */

contract FreezableToken is StandardToken, Ownable {

  using SafeMath for uint;
  uint public unfreezeProcessTime = 12 hours;
  uint public freezeTotal;
  uint public curId;
  uint public minFreeze = 1000000;

  mapping (address => uint) public freezes;
  mapping (address => uint) public unfreezes;
  mapping (address => uint) public lastUnfreezeTime;
  mapping (uint => address) public freezerAddress;
  mapping (address => uint) public freezerIds;
  mapping (address => bool) public blackLists;
  /* This notifies clients about the amount frozen */
  event Freeze(address indexed from, uint value);
  
  /* This notifies clients about the amount unfrozen */
  event Unfreeze(address indexed from, uint value);
  event WithdrawUnfreeze(address indexed sender, uint unfreezeAmount);
  event SettleUnfreeze(address indexed freezer, uint value);

  event BlackList(address indexed target, bool block);

    /**
   * Limit token transfer until the crowdsale is over.
   *
   */
  modifier allowTransfer(address _from, address _to) {
    require(!blackLists[_from]);
    require(!blackLists[_to]);
    _;
  }

  function freezeOf(address _tokenOwner) public view returns (uint balance) {
    return freezes[_tokenOwner];
  }

  function unfreezeOf(address _tokenOwner) public view returns (uint balance) {
    return unfreezes[_tokenOwner];
  }

  function freeze(uint _value) public returns (bool success) {
    if (freezerIds[msg.sender] == 0) {
      curId = curId.add(1);
      freezerIds[msg.sender] = curId;
      freezerAddress[curId] = msg.sender;
    }

    require(_value <= balances[msg.sender]); 
    //0 not allowed
    require (_value >= minFreeze); 
    address sender = msg.sender;
    balances[sender] = balances[sender].sub(_value);
    freezeTotal = freezeTotal.add(_value);
    freezes[sender] = freezes[sender].add(_value);
    emit Freeze(sender, _value);
    return true;
  }
  
  function unfreeze(uint _value) public returns (bool success) {
    require(_value <= freezes[msg.sender]);  
    //0 not allowed
    require (_value > 0); 
    address sender = msg.sender;
    freezes[sender] = freezes[sender].sub(_value);
    lastUnfreezeTime[sender] = block.timestamp;
    freezeTotal = freezeTotal.sub(_value);
    unfreezes[sender] = unfreezes[sender].add(_value);
    emit Unfreeze(sender, _value);
    return true;
  }

  function blackList(address _target, bool _block) onlyOwner public returns (bool success) {
    blackLists[_target] = _block;
    emit BlackList(_target, _block);
    return true;
  }

  function transfer(address _to, uint _value) allowTransfer(msg.sender, _to) public returns (bool success) {
    // Call StandardToken.transfer()
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint _value) allowTransfer(_from, _to) public returns (bool success) {
    // Call StandardToken.transferForm()
    return super.transferFrom(_from, _to, _value);
  }

  function withdrawUnfreeze() public returns (bool success) {
    address sender = msg.sender;
    uint unfreezeAmount = unfreezes[sender];
    uint unfreezeTime = lastUnfreezeTime[sender].add(unfreezeProcessTime);
    require(unfreezeAmount > 0);
    require(block.timestamp > unfreezeTime);

    unfreezes[sender] = 0;
    balances[sender] = balances[sender].add(unfreezeAmount);
    emit WithdrawUnfreeze(sender, unfreezeAmount);
    return true;
  }

  function ownerSettleUnfreeze(address _freezer) onlyOwner public returns (bool success) {
    uint unfreezeAmount = unfreezes[_freezer];
    uint unfreezeTime = lastUnfreezeTime[_freezer].add(unfreezeProcessTime);
    require(unfreezeAmount > 0);
    require(block.timestamp > unfreezeTime);

    unfreezes[_freezer] = 0;
    balances[_freezer] = balances[_freezer].add(unfreezeAmount);
    emit SettleUnfreeze(_freezer, unfreezeAmount);
    return true;
  }

  function ownerSetProcessTime(uint _newTime) onlyOwner public returns (bool success) {
    unfreezeProcessTime = _newTime;
    return true;
  }

  function ownerSetMinFreeze(uint _newMinFreeze) public returns (bool success) {
    minFreeze = _newMinFreeze;
    return true;
  }
}