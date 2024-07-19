# Solidity Data Types: Comparison with TypeScript

> Solidity, like TypeScript, is a statically typed language, which means variable types are declared explicitly. 
> This is different from JavaScript, which is dynamically typed. Understanding these differences is crucial for Web2 developers transitioning to Solidity.

> Keywords like `public`, `internal`, etc. will be explained in the next section.


## 1. Boolean
- Solidity: `bool`
- JavaScript/TypeScript: `boolean`

Both languages use `true` and `false`. The usage is very similar:

```typescript
// TypeScript
let isActive: boolean = true;
```

```solidity
// Solidity
bool isActive = true;
```

## 2. Integers
Solidity provides two main categories of integer types:

* Unsigned Integers (uint): These start from 0 and can only represent non-negative numbers.
* Signed Integers (int): These can represent both positive and negative numbers.

### Unsigned Integers
* Range: `uint8`, `uint16`, `uint24`, ..., `uint256`
* The upper limit is 2^n - 1, where n is the number of bits.i.e., `uint8` is ranging from 0 to 2^8 - 1.
* All unsigned integers start from 0

```solidity
uint8 smallPositive = 0;  // Minimum value for any uint
uint8 maxUint8 = 255;     // Maximum value for uint8 (2^8 - 1)
uint256 maxUint = 115792089237316195423570985008687907853269984665640564039457584007913129639935;  // Maximum value for uint256 (2^256 - 1)
```

### Signed Integers

* Range: `int8`, `int16`, `int24`, ..., `int256`
* Can represent both positive and negative numbers
* The range is from -2^(n-1) to 2^(n-1) - 1, where n is the number of bits

```solidity
int8 minInt8 = -128;   // Minimum value for int8 (-2^7)
int8 maxInt8 = 127;    // Maximum value for int8 (2^7 - 1)
int256 minInt = -57896044618658097711785492504343953926634992332820282019728792003956564819968;  // Minimum value for int256 (-2^255)
int256 maxInt = 57896044618658097711785492504343953926634992332820282019728792003956564819967;   // Maximum value for int256 (2^255 - 1)
```

### Key Differences from JavaScript/TypeScript

1. **Unsigned Integers**: JavaScript/TypeScript don't have native unsigned integer types. All numbers in JavaScript are double-precision 64-bit floating-point numbers.
   ```javascript
   // JavaScript - no native unsigned integers
   let num = 42;  // This could be positive, negative, or zero
   ```
   
   ```solidity
    // Solidity
    uint8 num = 42;  // This can only be 0 or positive, up to 255    
   ``` 
2. **Explicit Size**: In Solidity, you must choose the size of your integer explicitly, which affects both its range and gas consumption.
3. **No Implicit Conversion**: Solidity doesn't allow implicit conversion between signed and unsigned integers to prevent unexpected behavior.
   ```solidity
   uint8 a = 5;
   int8 b = -1;
   // uint8 c = a + b;  // This would cause a compile error
   int8 c = int8(a) + b;  // This is valid, c would be 4 
   ```


### Address
> `address`: Cannot receive Ether directly. If you try to send Ether to a regular address, the transaction will fail.
> 
> `address payable`: Can receive Ether. This type is designed to handle Ether transfers.

This is unique to Ethereum and Solidity. Both `address` and `address payable` are classified as value types, not reference types.

The key difference is that `address` **CAN NOT** be used to receive and sent *Ether*, while `address payable` **CAN**. 

```solidity
// Solidity
address owner = 0x123...;
address payable recipient = payable(0x456...);
```

In JavaScript/TypeScript, Ethereum addresses are typically handled as strings and validated using libraries or custom functions.
```typescript
// TypeScript
let owner: string = "0x123...";
```

#### Available methods

`address`:
* `balance`: to check the balance of the address
* `code`: to get the code at the address (for contracts)


`address payable`: Has all the methods of address, plus:
* `transfer(uint256 amount)`: Sends Ether to the address, throws on failure
* `send(uint256 amount)`: Sends Ether to the address, returns bool (true on success, false on failure)
* `call{value: amount}("")`: Low-level function to send Ether and data to an address, it's recommended to use `call` now for one will know it's success or failure.


```solidity
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
```
## 3. String and Bytes
Solidity has two types for dealing with string data: `string` and `bytes`.

### `string`

```solidity
string public name = "Alice";
```

* Used for UTF-8 encoded data.
* Dynamic size, but can be expensive to manipulate.
* Limited built-in operations (no native concatenation or length).

### `bytes`

* `bytes` is similar to string but allows length and index-access operations.
* `bytes1` to `bytes32` are fixed-size byte arrays.
* More gas-efficient than string for certain operations.

```solidity
// Solidity
bytes32 hash = 0x123...;
bytes memory dynamicBytes = new bytes(10);
```

In JavaScript/TypeScript, you often work with hex strings and convert them to byte arrays when needed.
```typescript
// TypeScript
let hash: string = "0x123...";
let dynamicBytes: Uint8Array = new Uint8Array(10);
```

## 4. Arrays

* Arrays in Solidity can be either fixed-size or dynamic and can contain any type, including `structs` and `mappings`.
* *Solidity* distinguishes between storage and memory arrays; TypeScript doesn't have this concept.
* There's gas costs associated with array operations in Solidity, so it's important to use them efficiently.

> Memory arrays must have a fixed size.

### Array Methods
* `.push()`: Adds an element to the end of a dynamic array.
* `.pop()`: Removes the last element from a dynamic array.
* `.length`: Returns the current length of the array.

### Fixed-Size Arrays

```solidity
uint[5] public fixedArray = [1, 2, 3, 4, 5];
bytes32[3] public fixedByteArray;

function memoryArray(uint[] memory _arr) public pure returns (uint[] memory) {
    uint[] memory newArray = new uint[](5); // must specify size in memory
    for (uint i = 0; i < 5; i++) {
        newArray[i] = _arr[i];
    }
    return newArray;
}

```
* Size is determined at declaration and cannot be changed.
* More gas-efficient than dynamic arrays.
* Automatically initialized with default values (0 for uint, empty bytes for bytes32, etc.).

### Dynamic Arrays
> Returning dynamic arrays from external functions is not supported in Solidity.
> Nested dynamic arrays are not supported in Solidity

```solidity
uint[] public dynamicArray;
bytes32[] public dynamicByteArray;
```
* Size can change after declaration.
* More flexible but less gas-efficient.
* Must be initialized before use.

> If the data set is large and the length is not known in advance, consider using mappings or other data structures.


## 5. Mappings
> Mappings are more gas-efficient for lookups in large datasets compared to arrays.

Mappings in Solidity are hash tables, which are virtually initialized such that every possible key exists and is mapped to a value.

```solidity
mapping(address => unint) public balances;
mapping(uint => mapping(uint => bool)) public grid;
```

* Mappings in Solidity CAN'T be iterated over, and the number of keys is not stored, which means you can't check if a key exists and can't get a list of keys or values.
* No Length or Concept of "Empty": All keys exist and return the default value if not set.

```solidity
contract MappingExample {
    mapping(address => uint) public balances; // store the balance of each address
    mapping(address => mapping(address => bool)) public isAllowed; // determine if an address is allowed to spend another address's funds

    function updateBalance(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }

    function setAllowed(address spender) public {
        isAllowed[msg.sender][spender] = true;
    }

    function getBalance(address account) public view returns (uint) {
        return balances[account];
    }
}
```

### 6. Structs
Structs in Solidity allow you to create custom types that group together related data.

* Nesting: You can nest structs within other structs, but be cautious with circular references.
* There's two ways of storing structs: in `memory` or in `storage`. 
    * Storage structs are stored on the blockchain.
    * Memory structs are temporary and exist only during function execution.
```solidity
contract ClientBook {
	struct Person {
		string name;
		bool isVip;
		address walletAddress;
	}

	Person[] public clients;

	function addClient(string memory name, bool isVip, address walletAddress) public {
		clients.push(Person(name, isVip, walletAddress));
	}

	function getClientInfo(address _address) public view returns (Person memory) {
		for (uint256 i = 0; i < clients.length; i++) {
			if (clients[i].walletAddress == _address) {
				return clients[i];
			}
		}
		return Person("", false, address(0));
	}
}
```

### 7. Enums

* Solidity enums are often used for on-chain state management; 
* The syntax is quite similar to TypeScript enums.

```solidity
contract BaseContract {
	// use enum to make uint 0, 1, 2 into Pending, Active & Inactive	
	enum State { Pending, Active, Inactive }

	State public contractState;

	function setState(State _state) public {
		contractState = _state;
	}

	function getState() public view returns (State) {
		return contractState;
	}	
}
```

### 8. mutable & `immutable` State Variables

In Solidity, state variables can be declared as `immutable` to optimize gas costs and prevent reassignment(strengthen security). 
There's no `mutable` keyword in Solidity, everything is mutable by default.

For example, we could make sure no one can change the owner of a contract by declaring it as `immutable`.
```solidity
contract ImmutableExample {
		address public immutable owner; // by making own immutable, we can't change the owner after deployment

		constructor() {
				owner = msg.sender; // once set, the owner can't be changed
		}
}
```
