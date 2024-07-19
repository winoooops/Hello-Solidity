# Interfaces & Abstract Contracts

## Interfaces

In Solidity, an interface is a contract that defines a set of function signatures without their implementations.

* Defines a contract's API
* Cannot contains state variables or constructors
* All function declarations must be external
* Unlike Typescript, no optional functions are allowed

```solidity
interface IERC20 {
	function totalSupply() external view returns (uint256);	
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool); 
	function convertToFiat(uint256 amount, string memory currency) external pure returns (uint256);
}
```

## Abstract Contracts

An abstract contract in Solidity is a contract that contains at least one function without its implementation, which makes it impossible to deploy directly.

The purpose of having an *abstract contract* is to: 
* Provide a base implementation for derived contracts, 
* Define common structures and behaviors, 
* Allow for code reuse and standardization.



## Real-World Example: Simple Lending Platform

First, let's define an interface for the lending platform in `./contracts/4/ILendingPlatform.sol`:

```solidity
interface ILendingPlatform {
	function deposit() external payable;
	function borrow(uint256 amount) external;
	function repay(uint256 amount) external payable;
	function withdraw(uint256 amount) external;
	
	event Deposit(address indexed user, uint256 amount);
	event Borrow(address indexed user, uint256 amount);
	event Repay(address indexed user, uint256 amount);
	event Withdraw(address indexed user, uint256 amount);
}
```

Now, Let's create an abstract contract for the lending platform in `./contracts/4/BaseLendingPlatform.sol`:

```solidity
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
```

Finally, we could implement a concrete lending platform contract in `./contracts/4/SimpleLendingPlatform.sol`:

```solidity
import {BaseLendingPlatform} from "./BaseLendingPlatform.sol";

contract SimpleLendingPlatform is BaseLendingPlatform {
	uint256 private constant BORROW_LIMIT = 80;
	
	function _getBorrowLimit(address user) internal view override returns (uint256) {
		return (balances[user] * BORROW_LIMIT) / 100;
	}
}
```

To conclude, interfaces and abstract contracts in Solidity are powerful tools that allow developers to define a contract's API and 
provide a base implementation for derived contracts. 

By using interfaces and abstract contracts, developers can 
* Enforce specific function signatures in implementing contracts 
* Enable interaction with unknown contracts
* Allow for code reuse and standardization.