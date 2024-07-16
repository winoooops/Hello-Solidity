// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BaseToken {
    // State variables
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    address public owner;

    // Maximum supply of tokens
    uint256 public constant MAX_SUPPLY = 21000000;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);

    // Constructor
    constructor(uint256 initSupply) {
        require(initSupply <= MAX_SUPPLY, "Initial supply exceeds maximum supply");
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
    function transfer(address recipient, uint256 amount) public virtual {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    // Mint function with access control
    function mint(address to, uint256 amount) public onlyOwner virtual  {
        require(totalSupply + amount <= MAX_SUPPLY, "Minting would exceed maximum supply");
        totalSupply += amount;
        balances[to] += amount;
        emit Mint(to, amount);
    }

    // Burn function
    function burn(uint256 amount) public virtual {
        require(balances[msg.sender] >= amount, "Burn amount exceeds balance");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burn(msg.sender, amount);
    }

    // Fallback function
    fallback() external payable {
        revert("This contract does not accept direct payments");
    }

    // Receive function
    receive() external payable {
        revert("This contract does not accept direct payments");
    }
}

contract NewPepeToken is BaseToken {
    string public name = "New Pepe";
    string public symbol = "NPEPE";
    uint8 public decimals = 18;

    uint8 public burnRate = 1;

    constructor(uint256 initSupply) BaseToken(initSupply) {
       // additional contract init if needed
    }

    /*
     * "Burn on transfer": create deflationary pressure on the token supply
     * on each tx, burn 1% of the transfer amount each out of the totalSupply
    */
    function transfer(address recipient, uint256 amount) public override {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        uint256 burnAmount = amount * burnRate / 100;
        uint256 transferAmount = amount - burnAmount;

        balances[msg.sender] -= amount;
        balances[recipient] += transferAmount;

        super.burn(burnAmount);

        emit Transfer(msg.sender, recipient, transferAmount);
        emit Transfer(msg.sender, address(0), burnAmount); // burning is transferring to address 0
        emit Burn(msg.sender, burnAmount);
    }

    // Mint function with access control
    function mint(address to, uint256 amount) public onlyOwner override  {
       super.mint(to, amount);
    }

    // Burn function
    function burn(uint256 amount) public override  {
        super.burn(amount);
    }

    function setBurnRate(uint8 targetRate) public {
       require(targetRate <= 10, "burn rate can't exceed 10%.");
       burnRate = targetRate;
    }
}