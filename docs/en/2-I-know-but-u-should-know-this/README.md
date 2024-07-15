# I Know it's all Concept, but u should really know this

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
### 1. Contract Declaration & Inheritance(if applicable)
Defines the contract and its name. It's also capable of inheriting properties and methods from other contracts(Think of it as Class Inheritance).
```solidity
// create a contract called NewPepeToken that inherit ERC20's methods and properties 
contract NewPepeToken is ERC20 {}
```
### 2. State Variables
Stores the contract's state with its type on the blockchain.
```solidity
contract NewPepeToken {
    // define a state variable called totalSupply, which is type of `uint`(unsigned integer of 256 bits)) 
    uint public totalSupply;
}
```
### 3. Constructor
Initializes the contract when it's deployed. Runs only once at the time of contract.
```solidity
contract NewPepeToken {
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
 contract NewPepeToken {
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
### 5. Modifiers
Some functions are only allowed in certain conditions, i.e., only contract owner can do something.
```solidity
contract NewPepeToken {
    // Modifier for access control
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
```
### 6. Events
### 7. Fallback and Receive Functions
### 8. Error Handling