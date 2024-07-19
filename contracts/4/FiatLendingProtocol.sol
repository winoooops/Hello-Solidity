// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./BaseLendingPlatform.sol";

contract FiatLendingProtocol is BaseLendingPlatform {
	uint256 private constant LIQUIDATION_THRESHOLD = 120; // Liquidation occurs when the collateral value drops below 120% of the borrowed amount
	uint256 private constant LIQUIDATION_PENALTY = 5; // 5% penalty on liquidation
	uint256 private constant COLLATERAL_RATIO = 80; // only 80% of the colleteral value can be borrowed
 
	mapping(address => uint256) public collaterals;
	
	event Liquidation(address indexed user, uint256);
	event AddCollateral(address indexed user, uint256 amount);
	
	function addCollateral(uint256 amount) internal {
		require(amount > 0 && amount < balances[msg.sender], "Invalid amount");
		collaterals[msg.sender] += amount;
		emit AddCollateral(msg.sender, amount);
	}
	
	function getCollateral(address user) public view returns (uint256) {
		return collaterals[user];
	}
	
	function _getBorrowLimit(address user) internal view override returns (uint256) {
		return collaterals[user] * COLLATERAL_RATIO / 100;
	}
	
	function borrow(uint256 amount) external override {
		require(isCollateralSufficient(msg.sender, amount), "Insufficient collateral, plz add more collateral to borrow");
		super.borrow(amount);
	}
	
	function isCollateralSufficient(address user, uint256 amount) public view returns (bool) {
		return amount <= collaterals[user] * COLLATERAL_RATIO / 100;
	}
	
	function repay(address user, uint)
	
}
