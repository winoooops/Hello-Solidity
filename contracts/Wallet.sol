// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Wallet {
	address public owner;
	
	constructor(){
		owner = msg.sender;
	}
	
	function deposit() public payable {
		require(msg.value > 0, "Deposit amount should be greater than 0");
		// Don't need to do anything since `payable` will automatically let the contract accept the Ether
	  // a best practise is to check if the balance
	}
	
	modifier onlyOwner() {
		require(msg.sender == owner, "Only the owner is allowed for this operation");
		_;
	}
	
	function getBalance() public view returns(uint) {
		return address(this).balance;
	}
	
	function showFiatValue(uint256 amount, uint16 rate) public pure returns(uint256) {
		return amount * rate;
	}
	
	function withdraw(uint256 amount) public onlyOwner {
		require(amount <= address(this).balance, "Insufficient funds");
		payable(address(this)).transfer(amount);
	}
	
	function transfer(address payable to, uint256 amount) public onlyOwner {
		require(amount <= address(this).balance, "Insufficient funds");
		to.transfer(amount);
	}
	
	function transfer(address payable[] to, uint256[] amount) public onlyOwner {
		require(amount.length == to.length, "Array length mismatch");
		for(uint i = 0; i < to.length; i++) {
			transfer(to[i], amount[i]);
		}
	}
}