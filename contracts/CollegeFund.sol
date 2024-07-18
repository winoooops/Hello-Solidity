// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CollegeFund {
    address public admin;
    uint256 public savingBalance;
    uint256 public checkingBalance;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the Administrator are allowed for this operation");
        _;
    }

    constructor() payable {
        require(msg.value > 0, "Initial deposit required");
        admin = msg.sender;
        deposit(msg.value);
    }

    function deposit(uint256 amount) public payable {
        require(msg.value == amount, "Incorrect deposit amount");
        checkingBalance += amount / 10;
        savingBalance += amount - amount / 10;
    }

    function withdrawFromChecking(uint256 amount, address payable wallet) public onlyAdmin {
        require(amount <= checkingBalance, "Insufficient funds");
        checkingBalance -= amount;
		    // !IMPORTANT: Solidity only support transfer of Ether from the contract, which means the contract can't manipulate external resources like a wallet address
        wallet.transfer(amount);
    }

    function transferToChecking(uint256 amount) public onlyAdmin {
        require(amount <= savingBalance, "Insufficient funds");
        savingBalance -= amount;
        checkingBalance += amount;
    }

    receive() external payable {
        deposit(msg.value);
    }
}