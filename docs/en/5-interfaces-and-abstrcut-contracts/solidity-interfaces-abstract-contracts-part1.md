# Interfaces and Abstract Contracts in Solidity

## 1. What are Interfaces and Abstract Contracts in Solidity?

### Interfaces

In Solidity, an interface is a contract that defines a set of function signatures without their implementations. 

Key characteristics:
- Cannot contain state variables
- Cannot contain constructors
- All declared functions must be external
- Cannot inherit from other contracts or interfaces

Purpose:
- Define a contract's API
- Enforce specific function signatures in implementing contracts
- Enable interaction with unknown contracts

Example:
```solidity
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    // ... other functions
}
```

### Abstract Contracts

An abstract contract in Solidity is a contract that contains at least one function without its implementation.

Key characteristics:
- Can contain state variables
- Can contain implemented functions
- Can inherit from other contracts
- Cannot be deployed directly

Purpose:
- Provide a base implementation for derived contracts
- Define common structures and behaviors
- Allow for code reuse and standardization

Example:
```solidity
abstract contract BaseERC20 {
    mapping(address => uint256) private _balances;

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual returns (bool);
}
```

## 2. Differences between Solidity and TypeScript

### Interfaces

Solidity:
- Cannot contain any implementation
- All functions must be external
- Cannot contain state variables

TypeScript:
- Can contain optional properties and methods
- Can be used with classes or object literals
- Can extend multiple interfaces

### Abstract Classes/Contracts

Solidity:
- Can contain both implemented and unimplemented functions
- Can contain state variables
- Cannot be instantiated directly

TypeScript:
- Similar to Solidity in terms of implemented and unimplemented methods
- Can have constructors
- Can be used with the `new` keyword but cannot be instantiated directly

Example comparisons:

Solidity Interface:
```solidity
interface IGreeter {
    function greet() external pure returns (string memory);
}
```

TypeScript Interface:
```typescript
interface IGreeter {
    greet(): string;
    optional?: number; // Solidity doesn't have optional properties
}
```

Solidity Abstract Contract:
```solidity
abstract contract BaseGreeter {
    string internal greeting;

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function greet() public view virtual returns (string memory);
}
```

TypeScript Abstract Class:
```typescript
abstract class BaseGreeter {
    protected greeting: string;

    constructor(greeting: string) {
        this.greeting = greeting;
    }

    abstract greet(): string;
}
```

In the next part, we'll dive into a real-world example that demonstrates the use of interfaces and abstract contracts in Solidity, comparing it with a similar implementation in TypeScript.

