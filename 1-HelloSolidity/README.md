# Introduction to Solidity 
> Solidity is a **statically-typed, contract-oriented** programming language designed for developing smart contracts that run on the Ethereum Virtual Machine (EVM). 
> It's used for implementing smart contracts on various blockchain platforms, most notably, Ethereum.

Key Features of Solidity
* Object-oriented, just like C++ & Java.
* Statically Typed, just like Typescript & Java.
* Supports inheritance, libraries and user-define types.

# A typical Solidity Project Architecture
A typical Solidity project often includes the following components:

* Contracts: The core Solidity files (.sol) containing your smart contract code.
* Tests: Usually written in JavaScript or Solidity, using frameworks like Truffle or Hardhat.
* Migrations: Scripts for deploying your contracts to various networks.
* Frontend: Often a web application that interacts with your deployed contracts.
* Config Files: For your development environment, network configurations, etc.
```
my-solidity-project/
├── contracts/
│   ├── HelloWeb3.sol
│   └── ...
├── tests/
│   ├── HelloWeb3.test.js
│   └── ...
├── migrations/
│   ├── 1_initial_migration.js
│   └── 2_deploy_contracts.js
├── src/
│   ├── index.html
│   ├── app.js
│   └── ...
├── truffle-config.js (or hardhat.config.js)
└── package.json
```

# Basic Solidity Contract Example
> To write, compile and run Solidity, use https://remix.ethereum.org/

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract HelloWeb3 {
    string public hello = "Hello Web3";

    address payable public seller;
    address payable public buyer;

    constructor(string memory _text) {
        hello = _text;
    }

    struct Order {
        string description;
        bool isCompleted;
    }

    function confirmOrder() public {
        buyer = payable(msg.sender);
    }
}
```

* the beginning of a contract usually contains license information
* `contract` keyword are reserved to declare a new contract
* when declaring a variable, do it like:
    ```
    <type> [visibility] [state mutability] <name> [= <initial_value>];
    ```
* when declaring a function, follow this rule:
    ```
     function <name>(<parameter_types>) [visibility] [state mutability] [returns (<return_types>)] {
        // function body
     }
    ```
* when declaring a structure(like an Object in Javascript, but with more rigid and statically typed)
    ```
    struct <name> {
        <type> <field_name>;
        // ... more fields
    }
    ```

