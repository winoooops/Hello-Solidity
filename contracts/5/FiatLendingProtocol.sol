// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./BaseLendingPlatform.sol";

contract FiatLendingProtocol is BaseLendingPlatform {
	uint256 private constant LIQUIDATION_THRESHOLD = 125; // Liquidation occurs when the collateral value drops below 125% of the borrowed amount
	uint256 private constant LIQUIDATION_PENALTY = 5; // 5% penalty on liquidation
	uint256 private constant COLLATERAL_RATIO = 80; // only 80% of the collateral value can be borrowed
	
	mapping(address => uint256) public collaterals;
	
	event Liquidation(address indexed user, uint256);
	event AddCollateral(address indexed user, uint256 amount);
	
	function addCollateral(uint256 amount) external {
		require(amount > 0 && amount < balances[msg.sender], "Invalid amount");
		collaterals[msg.sender] += amount;
		emit AddCollateral(msg.sender, amount);
	}
	
	function getCollateral(address user) external view returns (uint256) {
		return collaterals[user];
	}
	
	function _getBorrowLimit(address user) internal view override returns (uint256) {
		return collaterals[user] * COLLATERAL_RATIO / 100;
	}
	
	function borrow(uint256 amount) public override {
		require(isCollateralSufficient(msg.sender, amount), "Insufficient collateral, plz add more collateral to borrow");
		super.borrow(amount);
	}
	
	function isCollateralSufficient(address user, uint256 amount) public view returns (bool) {
		return amount <= collaterals[user] * COLLATERAL_RATIO / 100;
	}
	
	function liquidate(address user) external {
		require(validLiquidation(user), "User's position is not liquidated");
		
		borrows[user] = 0;
		
		uint256 liquidationAmount = _getLiquidationAmount(user);
		collaterals[user] -= liquidationAmount;
		balances[user] -= liquidationAmount;
		payable(address(this)).transfer(_getLiquidationPenalty(liquidationAmount)); // the protocol keeps the penalty if the liquidation happen
		
		emit Liquidation(user, liquidationAmount);
	}
	
	function validLiquidation(address user) internal view returns (bool) {
		if(borrows[user] == 0) return false;
		return _getLiquidationAmount(user) >= collaterals[user];
	}
	
	function _getLiquidationAmount(address user) internal view returns (uint256) {
		uint256 debt = borrows[user];
		uint256 liquidationAmount = debt * LIQUIDATION_THRESHOLD / 100;
		
		return liquidationAmount + _getLiquidationPenalty(liquidationAmount);
	}
	
	function _getLiquidationPenalty(uint256 amount) internal pure returns (uint256) {
		return amount * LIQUIDATION_PENALTY;
	}
}
