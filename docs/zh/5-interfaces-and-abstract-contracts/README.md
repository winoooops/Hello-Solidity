# 接口和抽象合约

## 接口

在Solidity中，接口是一个定义了一组函数签名但没有具体实现的合约。

* 定义了合约的API
* 不能包含状态变量或构造函数
* 所有函数声明必须是`external`
* 与TypeScript不同，不允许有可选函数

```solidity
interface IERC20 {
    function totalSupply() external view returns (uint256);    
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool); 
    function convertToFiat(uint256 amount, string memory currency) external pure returns (uint256);
}
```

## 抽象合约

Solidity中的抽象合约是至少包含一个没有实现的函数的合约，这使得它无法直接部署。

使用*抽象合约*的目的是：
* 为派生合约提供基本实现
* 定义通用结构和行为
* 允许代码重用和标准化

## 现实世界的例子：简单借贷平台

首先，让我们在`./contracts/4/ILendingPlatform.sol`中定义借贷平台的接口：

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

现在，让我们在`./contracts/4/BaseLendingPlatform.sol`中创建借贷平台的抽象合约：

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
        require(balances[msg.sender] >= amount, "余额不足");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
    
    // 定义为internal，以便派生合约可以调用
    // 记得标记为`virtual`，以便派生合约可以重写
    function _getBorrowLimit(address user) internal view virtual returns (uint256);
    
    function borrow(uint256 amount) external override {
        uint256 borrowLimit = _getBorrowLimit(msg.sender);
        require(borrows[msg.sender] + amount <= borrowLimit, "超过借款限额");
        borrows[msg.sender] += amount;
        emit Borrow(msg.sender, amount);
    }
    
    function repay(uint256 amount) external payable override {
        require(borrows[msg.sender] > 0, "没有未偿还的借款");
        uint256 repayAmount = msg.value > borrows[msg.sender] ? borrows[msg.sender] : msg.value;
        emit Repay(msg.sender, repayAmount);
        
        // 将多余的金额返还给用户
        if(msg.value > repayAmount) {
            payable(msg.sender).transfer(msg.value - repayAmount);
        }
    }
}
```

最后，我们可以在`./contracts/4/SimpleLendingPlatform.sol`中实现一个具体的借贷平台合约：

```solidity
import {BaseLendingPlatform} from "./BaseLendingPlatform.sol";

contract SimpleLendingPlatform is BaseLendingPlatform {
    uint256 private constant BORROW_LIMIT = 80;
    
    function _getBorrowLimit(address user) internal view override returns (uint256) {
        return (balances[user] * BORROW_LIMIT) / 100;
    }
}
```

总结一下，Solidity中的接口和抽象合约是强大的工具，允许开发者定义合约的API并为派生合约提供基本实现。

通过使用接口和抽象合约，开发者可以：
* 在实现合约中强制执行特定的函数签名
* 实现与未知合约的交互
* 允许代码重用和标准化

如果你想挑战一下自己，试试实现一个更复杂的借贷平台，包括抵押品和清算功能！
我的示例代码在`./contracts/5/FiatLendingPlatform.sol`中。
