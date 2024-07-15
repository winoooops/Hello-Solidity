// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract NewPepeToken {
    // State variables
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    address public owner;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Mint(address indexed to, uint256 amount);

    // Constructor
    constructor(uint256 initSupply) {
        totalSupply = initSupply;
        balances[msg.sender] = initSupply;
        owner = msg.sender;
    }

    // Modifier for access control
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Transfer function
    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    // Mint function with access control
    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply += amount;
        balances[to] += amount;
        emit Mint(to, amount);
    }

    // Fallback function
    fallback() external payable {
        // This function is called for all messages sent to this contract, except plain Ether transfers
        // (there is no other function except the receive function).
        // Any call with non-empty calldata to this contract will execute the fallback function (even if Ether is sent along with the call).
    }

    // Receive function
    receive() external payable {
        // This function is called for plain Ether transfers, i.e. for every call with empty calldata.
    }
}