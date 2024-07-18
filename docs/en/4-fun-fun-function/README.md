# Solidity Functions: Advanced Features and Keywords

## 1. Function Visibility Keywords

Solidity provides four visibility specifiers for functions:`public`, `private`, `external`, and `internal` are mutually exclusive. 
This means you cannot combine them (e.g., you can't have a function that is both `public` and `external`).

Here's a breakdown of how these specifiers relate to each other:

1. `public` vs `external`:
	* Both can be called from outside the contract.
	* public functions can also be called internally.
	* external functions can only be called from outside the contract.
2. `private` vs `internal`:
	* Both can be called from within the contract.
	* private functions can only be called from within the current contract.
	* internal functions can also be called from derived contracts.

### Why Have 2 aspects of Visibility?

Here's why each pair exists:

1. `public` vs `external`:
	* public functions are versatile but less gas-efficient for external calls, which can be called internally and externally.
	* external functions are more gas-efficient for external calls but can't be called internally, which can be called by other contracts.
2. `private` vs `internal`:
	* private functions provide the highest level of encapsulation, which means only the **SAME** contract can call them.
	* internal functions allow for code reuse in inherited contracts, which means derived contracts can also call them.

Now let's showcase this using an example contract called `Base` in `./contracts/visibility.sol`:

First, let's define the contract and its state variables:
```solidity 
contract Base {
	function publicFunc() public pure returns (string memory) {
		return "This is public";
	}
	
	function privateFunc() private pure returns (string memory) {
		return "This is private";
	}
	
	function internalFunc() internal pure returns (string memory) {
		return "This is internal";
	}
	
	function externalFunc() external pure returns (string memory) {
		return "This is external";
	}
}
```

and then test the effects of visibility specifiers using a derived contract called `Derived` and a test contract called `Consumer`:
```solidity
contract Derived is Base {
	function test() public pure returns (string memory) {
	  // public function can be called internally and externally, so a derived contract can call it
		return publicFunc();         // This will worked.
		// return internalFunc();   // This will work.
		// return privateFunc();    // This will NOT work.
		// return externalFunc();   // This will NOT work.
		
	}
}

contract Consumer {
	function test() public pure returns (string memory) {
		Base b = new Base();
		// can only called public and external functions
		
		// return b.publicFunc();    // This will work.
		return b.externalFunc();     // This will work.
		// return b.privateFunc();   // This will NOT work.
		// return b.internalFunc();  // This will NOT work.
	}
}
```

In this case, 
* `publicFunc` can be called on external and internal contracts(including derived contracts), 
* `privateFunc` can only be called within the SAME contract.
* `internalFunc` can be called within the same contract and derived contracts.
* `externalFunc` can only be called from outside the contract.

The reason why Solidity have additional `internal` & `external` keywords is to provide fine-grained control over function accessibility and to optimize gas usage.

## 2. State Mutability Keywords

### `view` 
In Solidity, view functions are indeed similar to `readonly` in other languages, such as Java. But in Solidity, I have to take gas consumption into consideration.
* It promises not to modify the state of the contract.
* Does not cost gas when called externally but costs gas when called internally.

### `pure`
* It promises not to read or modify the state of the contract. A common use case for `pure` functions is to perform computations on the input parameters.
* like `view`, it don't cost gas when called externally but costs gas when called internally.

### `payable`
We've covered this in the previous section, but it's worth mentioning again. The `payable` keyword allows a function to receive Ether. 
This is essential for functions that need to receive Ether, such as a function that accepts payments.
> Note: A function with `payable` keyword will automatically receive Ether, but it's important to check the amount of Ether received and handle it properly to avoid reentrancy attacks

### Real-world Example: Wallet Contract
```solidity
pragma solidity ^0.8.0;

contract Wallet {
	address public owner;
	
	constructor(){
		owner = msg.sender;
	}
	
	function deposit() public payable {
		require(msg.value > 0, "Deposit amount should be greater than 0");
		// Don't need to do anything since `payable` will automatically let the contract accept the Ether
	  // a best practise is to check if the balance
	}
	
	function getBalance() public view returns(uint) {
		return address(this).balance;
	}
	
	function showFiatValue(uint256 amount, uint16 rate) public pure returns(uint256) {
		return amount * rate;
	}
}
```
In this example, given in `./contracts/Wallet.sol`: 
* Since we need `deposit` function to actually receive Ether, so it need to have a `payable` keyword.
* `getBalance` function is a `view` function because it only reads the state of the contract.
* `showFiatValue` function is a `pure` function because it only performs computations on the input parameters.

## 3. Function Modifiers
Function Modifiers are just like decorators in Java. They are used to modify the behavior of functions in Solidity.
One of the most common use cases for function modifiers is to add access control to functions.
In `Wallet.sol`, we can add a `onlyOwner` modifier to restrict access to certain functions to the contract owner. Say we have a `withdraw` function and we want only the owner to be able to call it.

```solidity
contract Wallet {
	address public owner;
	
	modifier onlyOwner() {
		require(msg.sender == owner, "Only the owner is allowed for this operation");
		_;
	}
	
	function withdraw(uint256 amount) public onlyOwner {
		require(amount <= address(this).balance, "Insufficient funds");
		payable(address(this)).transfer(amount);
	}
	// the rest of the contract is the same
	// ...
}
```

## 4. Function Overloading
Solidity supports function overloading, allowing multiple functions with the same name but different parameter types. 

This is a bit like Java, but in Solidity, you can't have the same number of parameters with different types.

For example, we could add a `transfer` function to the `Wallet` contract that can do single transfer and batch transfer.


```solidity
contract Wallet {
	function transfer(address payable to, uint256 amount) public onlyOwner {
		require(amount <= address(this).balance, "Insufficient funds");
		to.transfer(amount);
	}
	
	function transfer(address payable[] to, uint256[] amount) public onlyOwner {
		require(amount.length == to.length, "Array length mismatch");
		for(uint i = 0; i < to.length; i++) {
			transfer(to[i], amount[i]);
		}
	}
	
	// the rest of the contract is the same
	// ...
}
```
