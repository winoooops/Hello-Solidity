# Errors and Error Handling
> In Solidity, errors are a way to indicate that something unexpected or invalid has occurred during the execution of a smart contract. 
> Solidity uses **state-reverting** exceptions to handle errors. Such an exception undoes all changes made to the state in the current call (and all its sub-calls) and flags an error to the caller.
> Error handling refers to the mechanisms and practices used to deal with these errors gracefully.

Whey exceptions happens in a sub-call (e.g., a function call), the error is propagated up(bubble up) the call stack until it reaches the top-level function. 
If the error is not caught and handled(not caught in a `try/catch`), the transaction is reverted, and all changes made to the state are undone.

```solidity
contract A {
	function foo() public {
		B b = new B();
		b.bar(); // if bar() throws an exception, it will bubble up to foo(), and foo() will revert the transaction.
	}	
}

contract B {
	function bar() public {
		revert("Houston, we've got a problem.");
	}
}
```

In the above example, the errors stack is as follows: `bar() -> foo() -> top-level function`. If the error is not caught in `foo()`, the transaction is reverted, and all changes made to the state are undone.

However, for low-level calls (e.g., `call`, `delegatecall`, `staticcall`), the error is not propagated up the call stack. 

Instead, the return value of the call is checked to determine if the call was successful. If the call was unsuccessful, the function returns `false`, and the error must be handled manually.

```solidity
contract SimpleBank {
	mapping(address=>uint256) public accounts;
	
	function deposit() public payable {
		accounts[msg.sender] += msg.value;
	  (bool isSuccess,) = msg.sender.call{value: msg.value}(""); // if the call fails, isSuccess is false
		require(isSuccess, "Failed to send ether to msg.sender"); // must handle the error manually
	}
}
```



## **Panics** with `assert`
> `assert` should only be used internally, to check invariants and conditions that should never be false.
> It is used to indicate that something went terribly wrong and the contract is in an inconsistent state.

The `assert` function create an **error** of type `Panic(uint256)`, if the condition is false. 

* It should only be used for internal error checking
* A properly functioning contract should never trigger a `Panic`(`assert` condition should always be true).

```
Panic error codes:
- 0x00: Generic compiler-inserted panics
- 0x01: False assertion
- 0x11: Arithmetic overflow/underflow
- 0x12: Division or modulo by zero
- 0x21: Invalid enum conversion
- 0x22: Incorrect storage byte array encoding
- 0x31: .pop() on an empty array
- 0x32: Array access out of bounds
- 0x41: Too much memory allocation or oversized array
- 0x51: Call to an uninitialized internal function
```




## **Errors** with `require`
> `require` is used to validate user inputs and conditions that must be met for the contract to execute correctly.
> It will generate a generic error message if the condition is false.

`require` is used for checking external conditions. It comes with 3 overloads:
* `require(bool)`: Reverts the transaction without any data.
* `require(bool, string)`: Reverts the transaction with an `Error(string)`.
* `require(bool, error)`: Reverts the transaction with a custom, user supplied `error`.

Errors can also be triggered in other scenarios, such as:

* Failed `.transfer()` calls
* Contract creation that doesn't finish properly
* Receiving Ether in a non-payable function


```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Sharer {
    function sendHalf(address payable addr) public payable returns (uint balance) {
        require(msg.value % 2 == 0, "Even value required."); // check external conditions 
        uint balanceBeforeTransfer = address(this).balance;
        addr.transfer(msg.value / 2);
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2); // check if the internal state is consistent
        return address(this).balance; 
    }
}
```

## **Custom Errors** with `require` or `revert`
If you want to provide more context to the error message, you can use `require` or `revert` with a custom error message.

It also provides more **gas-efficient** error handling, as the error message is not stored on the blockchain.

```solidity
// in ./contracts/6/SimpleWire.sol

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

```

## Gas Efficiency in Error Handling
> The following outcomes are tested by 0xAA using Remix IDE with 0.8.17 compiler version, you could find more details in [WTF-Solidity](https://github.com/AmazingAng/WTF-Solidity/tree/main/15_Errors)
> 
> "We can see that the (custom) error consumes the least gas, followed by the `assert`, while the `require` consumes the most gas! Therefore, `error` not only informs the user of the error message but also saves gas."

You could also create your own test files in Remix with such code snippets to verify the gas consumption in the ballpark
 
> The reason for `require` without a message consuming more gas than `require` with a message is that the error message is stored in the blockchain, which consumes more gas.


```solidity
error ErrorMathInvalid(string msg);

contract testErrorGasConsumption {
    function testAssert() external pure { 
        assert(5 < 10); // estimated gas cost: 145
    }

     function testCustomErrorWithRevert() external pure{
        if(5 > 10) {
            revert ErrorMathInvalid("must follow math rules");  // estimated gas cost: 170
        }
    }

    function testRequireWithMessage() external pure {
        require(5<10, "must follow math rules");  // estimated gas cost: 189
    }

    function testRequireWithoutMessage() external pure {
        require(5 < 10);  // estimated gas cost: 211 
    }
}
```
