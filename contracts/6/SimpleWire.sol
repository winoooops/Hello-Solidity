// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

error InsufficientBalance(uint256 available, uint256 required);


contract SimpleWire {
	mapping(address => uint256) public balances;
	
	function deposit() external payable {
		require(msg.value > 0, "Deposit amount must be greater than 0");
		balances[msg.sender] += msg.value;
	}
	
	function transfer(address from, address to) external {
		if(msg.value <= balances[from]) {
			revert InsufficientBalance(balances[from], msg.value);
		}
		
		balances[from] -= msg.value;
		balances[to] += msg.value;
	}
}
