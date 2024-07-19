// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {BaseLendingPlatform} from "./BaseLendingPlatform.sol";

contract SimpleLendingPlatform is BaseLendingPlatform {
	uint256 private constant BORROW_LIMIT = 80;
	
	function _getBorrowLimit(address user) internal view override returns (uint256) {
		return (balances[user] * BORROW_LIMIT) / 100;
	}
}
