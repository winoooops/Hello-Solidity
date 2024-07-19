// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ILendingPlatform} from "./ILendingPlatform.sol";

abstract contract BaseLendingPlatform is ILendingPlatform {
	mapping(address => uint256) public balances;
	mapping(address => uint256) public borrows;
	
	function deposit() external payable override {
		balances[msg.sender] += msg.value;
		emit Deposit(msg.sender, msg.value);
	}
	
	function withdraw(uint256 amount) external override {
		require(balances[msg.sender] >= amount, "Insufficient balance");
		balances[msg.sender] -= amount;
		payable(msg.sender).transfer(amount);
		emit Withdraw(msg.sender, amount);
	}
	
	// defined as internal so that it can be called by derived contracts
	// remember to mark this as `virtual` so that derived contracts can override it
	function _getBorrowLimit(address user) internal view virtual returns (uint256);
	
	function borrow(uint256 amount) external override {
		uint256 borrowLimit = _getBorrowLimit(msg.sender);
		require(borrows[msg.sender] + amount <= borrowLimit, "Exceed borrow limit");
		borrows[msg.sender] += amount;
		payable(msg.sender).transfer(amount);
		emit Borrow(msg.sender, amount);
	}
	
	function repay(uint256 amount) external payable override {
		require(borrows[msg.sender] > 0, "No outstanding borrow");
		uint256 repayAmount = msg.value > borrows[msg.sender] ? borrows[msg.sender] : msg.value;
		emit Repay(msg.sender, repayAmount);
		
		// return excess amount back to the user
		if(msg.value > repayAmount) {
			payable(msg.sender).transfer(msg.value - repayAmount);
		}
	}
}
