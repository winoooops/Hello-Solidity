# I Know it's all Concept, but u should really know this
> This content is based on my personal interpretation on Smart Contracts, Solidity's implementation of Smart Contracts, and the Ethereum Virtual Machine (EVM) 
> and may contain inaccuracies or be incomplete in some aspects.
> 
> While I've made every effort to provide accurate information, the field of blockchain and smart contracts is complex and rapidly evolving.
> For the most up-to-date and comprehensive information, I strongly recommend referring to the official Solidity documentation:
> * In English: [Introduction to Smart Contracts](https://docs.soliditylang.org/en/v0.8.26/introduction-to-smart-contracts.html#introduction-to-smart-contracts)
> * In Chinese: [智能合约介绍](https://docs.soliditylang.org/zh/v0.8.19/introduction-to-smart-contracts.html)

## 1. What is Blockchain and What Does it Do?

A blockchain is a decentralized, distributed ledger technology that records transactions across many computers so that the record cannot be altered retroactively without the alteration of all subsequent blocks and the consensus of the network.
Key features of blockchain:

* Decentralization: No single authority controls the blockchain.
* Transparency: All transactions are visible to anyone on the network.
* Immutability: Once data is recorded, it's extremely difficult to change.
* Security: Uses cryptography to secure transactions and maintain integrity.

What blockchain does:

* Enables secure, transparent transactions without intermediaries
* Maintains a permanent, tamper-resistant record of transactions
* Facilitates trust in peer-to-peer networks
* Enables cryptocurrencies and decentralized applications (DApps)

## 2. What is a Smart Contract and What Does it Add to the Blockchain?
> A smart contract is a self-executing contract with the terms of the agreement between buyer and seller being directly written into lines of code. 
> The code and the agreements contained therein exist across a distributed, decentralized blockchain network. 

### Smart Contract Analogy: The Automated Coffee Shop
Imagine a coffee shop that operates entirely through smart contracts on a blockchain. Here's how it might work:

1.Menu (Contract Terms):
* Traditional: A board displays coffee types and prices.
* Smart Contract: The menu is code defining available drinks, prices, and conditions (e.g., sizes, add-ons).

2.Ordering (Initiating the Contract):
* Traditional: You tell the barista your order.
* Smart Contract: You use the coffee shop's app to select your drink. This triggers the smart contract.

3.Payment (Fulfilling Contract Conditions):
* Traditional: You pay before or after getting your coffee.
* Smart Contract: Your cryptocurrency is held in escrow. Payment is released only when conditions are met.

4.Preparation (Contract Execution):
* Traditional: Barista makes your coffee based on the order.
* Smart Contract: Automated machines (or baristas verified through IoT devices) prepare the drink. Each step is recorded on the blockchain.


5.Delivery (Contract Fulfillment):
* Traditional: Barista calls your name; you pick up your coffee.
* Smart Contract: Completion of your order is recorded on the blockchain. You confirm receipt through the app, releasing the payment.


Customization (Contract Conditions):
* Traditional: You ask for extra shots or syrup.
* Smart Contract: Customizations are coded conditions. Adding them automatically adjusts the price and preparation instructions.

Loyalty Program (Smart Contract Feature):
* Traditional: You collect stamps on a card for free drinks.
* Smart Contract: Your purchases are automatically recorded, and rewards (like free drinks) are automatically issued based on predefined conditions.

Disputes (Contract Enforcement):
* Traditional: You complain to the staff if your order is wrong.
* Smart Contract: Predefined conditions for issues (e.g., incorrect order, long wait times) automatically trigger refunds or compensations.



### What smart contracts add to blockchain:

New Possibilities: Smart contracts enable complex decentralized applications (DApps) and decentralized autonomous organizations (DAOs).

* Automation: Smart contracts automatically execute when predefined conditions are met.
* Precision: Smart contracts define rules and consequences in the same way a traditional contract does, but also automatically enforce those obligations.
* Speed and Efficiency: By automating processes, smart contracts can save time and reduce the need for intermediaries.
* Trust: The decentralized execution of smart contracts removes the need to trust a central authority or counterparty.

### What does Smart Contracts add to the Blockchain?
Smart contracts extend the utility of blockchain beyond simple value transfer, 
allowing for more complex and conditional transactions. 
They form the backbone of many blockchain applications, including decentralized finance (DeFi) protocols, non-fungible tokens (NFTs), and more.

## 3. Key Components of Smart Contracts and Their Implementation 
> A contract in the sense of Solidity is a collection of code (its functions) and data (its state) that resides at a specific address on the Ethereum blockchain.

A typical smart contract in Solidity usually includes the following key functional components:
### 1. Contract Declaration 
Defines the contract and its name. 
```solidity
// create a contract called BaseToken that inherit ERC20's methods and properties 
contract BaseToken {}
```
### 2. State Variables
Stores the contract's state with its type on the blockchain.
```solidity
contract BaseToken {
    // define a state variable called totalSupply, which is type of `uint`(unsigned integer of 256 bits)) 
    uint public totalSupply;
}
```
### 3. Constructor
Initializes the contract when it's deployed. Runs only once at the time of contract.
```solidity
contract BaseToken {
    uint256 public totalSupply;
    constructor(uint256 initSupply) {
        totalSupply = initSupply;
    }
}
```
### 4. Functions
* This is where most of the operations/behaviors of a blockchain are defined, thus make it intractable.
* it could be `public`, `private`, `internal` and `external`
```solidity
 contract BaseToken {
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    address public owner;
    
    function transfer(address recipient, uint256 amount) public {
        // transfer logics here
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply += amount;
        balances[to] += amount;
        owner = msg.sender; 
    }
}
```

### 5. Error Handling
Just like any other language, error handling is essential for Solidity. 
Solidity provides several mechanisms for handling errors:
#### `require(condition, error_message)`
* Used to validate inputs and conditions before execution. If the conditions are false, 
* it reverts the transaction and returns the error message.
    ```solidity
    contract BaseToken {
      uint256 public totalSupply;
      mapping(address => uint256) public balances;
      address public owner; 
   
      function mint(address to, uint256 amount) public {
          // check if the caller of the function is indeed the owner of the blockchain, if false, return the error message.
          require(msg.sender == owner, "only the owner can call the mint function");
          totalSupply += amount;
          balances[to] += amount; 
      }  
    }
    ```
#### `assert(condition)`
* if the condition is false, it reverts the transaction but consumes all the remaining gas.
* Should only be used to check conditions that are **never be false**.
```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 100000;
    uint256 public maxSupply = 210000000;
    
    function burn(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Burn amount exceeds balance");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        _assertInvariants();
    }
    
    // the natural of recursion make this extremely gas-intensive, should not be used on chain
    function _assertInvariants() internal view {
        // assert totalSupply never exceeds maxSupply
        assert(totalSupply <= maxSupply);

        // Assert that the sum of all balances equals the total supply
        uint256 totalBalances = 0;
        for (uint256 i = 0; i < uint256(type(uint160).max); i++) {
            if (balances[address(uint160(i))] > 0) {
                totalBalances += balances[address(uint160(i))];
            }
        }
        assert(totalSupply == totalBalances);
    }
}
```
#### `revert(error_message)` 
Explicitly reverts the current transaction and refunds all the remaining gas.

```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    
    function withdraw(uint256 amount) public {
        if (amount > balances[msg.sender]) {
            // reverts the transaction, user don't have to pay for the remaining gas fee.
            revert("Withdrawal amount exceeds balance");
        }
        // ... withdrawal logic
    }
}
```

### 6. Modifiers
Some functions are only allowed in certain conditions, i.e., only contract owner can do something.
```solidity
contract BaseToken {
    // Modifier for access control
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
```

### 7. Events
* Events are not designed to implementing contracts logics, they just provide ways for communication.
* Events don't return values to the caller. They simply log data to the blockchain's event log.
* Event can only be emitted by external contracts or services, i.e., Web Dapps.

```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Mint(address indexed to, uint256 amount);
    
    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance")
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        
        emit Transfer(msg.sender, recipient, amount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply += amount;
        balances[to] += amount;
        
        emit Mint(to, amount);
    }
}
```
In this example, the `Transfer` and `Mint` event is emitted after `transfer` & `mint` function are triggered. 
Then external applications can listen for those events to update their state or trigger actions.
The event creates a permanent record on the blockchain which could be referenced later.

### 8. Fallback and Receive Functions
> *Ether(ETH)* is the native cryptocurrency of the Ethereum network. 
> * It's used to transfer value and pay for transaction fees.
> * It can be sent between accounts and stored in contracts.
> * Ether has several denominations: 
>   * *Wei*: The smallest unit of Ether: `1Ether = 10^18 Wei` 
>   * *Gwei*: Often used as gas prices: `1Ether = 10^9 Gwei` & `1Gwei = 10^9 Wei`
>   * Other less commonly know units includes *Kwei*, *Mwei*, *Szabo*, and *Finney*.
>   
> *Gas* on the other hand, is a measure of computational efforts required to execute operations on the Ethereum Network. You can think of gas as energy tokens in an arcade
> * Gas price is denoted in Gwei/gas and can fluctuate based on network demand.
> * The total transaction fee is calculated as `Gas Used * Gas Price`, say, 
> if a tx uses 21,000 gas and the gas prices is 20 Gwei, then the fee would be 21,000 × 20 Gwei = 420,000 Gwei = 0.00042 ETH

#### `fallback`
The `fallback` function in solidity is a special function that only execute in 2 scenarios:
1. When a function, which is unexpected on the contract(does not exist on the contract), is called. 
2. When *Ether* is sent to the contract **with data**(non-empty calldata). In this case, it needs to be declared as `payable` to accept *Ether*

* `fallback` has no arguments and doesn't return anything.
* It's limited to 2,300 gas when called by another contract (to prevent security issues).

#### `receive`
`receive` gets called specifically when *Ether* is sent to the contract without any data.
* It must be declared as `payable`
* If not `receive` is defined but a payable `fallback` function exists, the `fallback` function will be called 

### 9. Inheritance 
It's also capable of inheriting properties and methods from other contracts(Think of it as Class Inheritance).
* use `is` keyword to inherit
* just like javascript, `super` is used to call the base implementation within an overridden function
* inherited contracts have access to non-private members of the base contract

#### `virtual`
Applying `virtual` to a function in a base contract allows it to be overridden in derived contracts.

> Always use `virtual` for functions in base contracts that you intend to be overridable.

```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    // using `virtual` to allows for override 
    function transfer(address recipient, uint256 amount) public virtual {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }
}
```

#### `override`
To explicitly override a function from a base contract.
Applied in the derived contract to functions that are overriding base contract functions.

> Always use `override` when overriding a function from a base contract.
> Omitting `override` when overriding a function will result in a compilation error.

```solidity
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
```
in this example, by inheriting from `BaseToken`, `NewPepeToken` gains a solid foundation of standard token functionality while adding its own unique features, 
particularly the burn-on-transfer mechanism while still capable of writing its own implementations.


## 4. Understanding the Ethereum Virtual Machine (EVM)

### What is the EVM?
The *Ethereum Virtual Machine (EVM)* is the runtime environment for smart contracts in Ethereum. 
It's a Turing-complete, stack-based virtual machine that executes bytecode. Every Ethereum node runs an *EVM* implementation, 
allowing them to execute the same instructions.

Imagine the EVM as a giant, global playground:
* **The Playground**: This is the EVM itself, a space where anyone can come and play (execute their code).
* **Playground Rules**: Just like a playground has rules for safety and fair play, the EVM has rules (its protocol) that everyone must follow.
* **Universal Design**: No matter where you are in the world, this playground looks and works exactly the same, just like how the EVM provides a consistent environment across all Ethereum nodes.

In this playground analogy, smart contracts are like pieces of playground equipment:
* **Slides and Swings**: Different types of smart contracts serve different purposes, just like various playground equipment.
* **Assembly Required**: Before placing equipment in the playground, it needs to be assembled (compiled to bytecode) according to the playground's specifications.
* **Usage Instructions**: Once installed, anyone can use the equipment (interact with the contract) according to its design.

### How the EVM Works

1. Contract Deployment:
    * Solidity code is compiled to EVM bytecode.
    * Bytecode is deployed to the Ethereum network.
2. Transaction Execution:
    * A transaction triggers contract execution.
    * EVM loads the contract's bytecode.
    * Executes instructions one by one.
3. State Changes: If execution is successful, state changes are recorded on the blockchain.
4. Gas Consumption:
    * Each operation consumes a predetermined amount of gas.
    * If gas runs out, execution stops and changes are reverted.

### Purpose of the EVM

* Smart Contract Execution: Provides a secure, isolated environment for executing smart contract code.
* Deterministic Execution: Ensures that the same input always produces the same output across all nodes.
* Decentralization: Allows for decentralized applications by providing a consistent execution environment across the entire Ethereum network.

### Key Features of the EVM

* **Stack-Based**: Uses a last-in-first-out (LIFO) stack for operations.
* **Gas Mechanism**: Uses "gas" to measure computational cost and prevent infinite loops
* **Opcodes**: Has a set of bytecode instructions (opcodes) that perform specific operations.
* **Data Storage**: The *Ethereum Virtual Machine* has three areas where it can store data
    * Stack: For temporary storage
    * Memory: Volatile memory that's reset between transactions
    * Storage: Persistent storage for contract state
> You can find more regarding Data Storage [here](DATA_STORAGE.md)

### Ethereum Message Calls
Imagine Ethereum as a big office building where each smart contract is an employee with their own office. 
Message Calls are like the internal communication system of this building. Contracts(employees) uses Message Calls to communicate with each other or send Ether around.

Each Message Calls contains:
* Who's calling (*source*)
* Who they're calling (*target*)
* What they're saying (*data payload*)
* Any money they're sending (*Ether*)
* Energy for the call (*gas*)
* What they heard back (*return data*)

> You can find more about Message Calls [here](MESSAGE_CALLS.md)

