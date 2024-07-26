// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ILendingPlatform {
	function deposit() external payable;
	function borrow(uint256 amount) external;
	function repay() external payable;
	function withdraw(uint256 amount) external;
	
	event Deposit(address indexed user, uint256 amount);
	event Borrow(address indexed user, uint256 amount);
	event Repay(address indexed user, uint256 amount);
	event Withdraw(address indexed user, uint256 amount);
}
