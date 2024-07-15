pragma solidity ^0.8.21;

contract HelloSolidity {
    string public greeting = "";

    address payable public seller;
    address payable public buyer;

    struct Order {
        string description;
        bool isCompleted;
    }

    function confirmOrder() public {
        buyer = payable(msg.sender);
    }

    constructor(string memory _text) {
        greeting = "Hello " + _text;
    }
}