# Solidity函数：高级特性和关键字

## 1. 函数可见性关键字

Solidity为函数提供了四种可见性说明符：`public`、`private`、`external`和`internal`，这些是互斥的。
这意味着你不能组合使用它们（例如，你不能有一个既是`public`又是`external`的函数）。

以下是这些说明符之间的关系：

1. `public` vs `external`：
   * 两者都可以从合约外部调用。
   * public函数也可以在内部调用。
   * external函数只能从合约外部调用。
2. `private` vs `internal`：
   * 两者都可以在合约内部调用。
   * private函数只能从当前合约内部调用。
   * internal函数也可以从派生合约中调用。

### 为什么需要两个方面的可见性？

每对存在的原因如下：

1. `public` vs `external`：
   * public函数versatile功能更全面，但对外部调用来说gas效率较低，可以内部和外部调用。
   * external函数对外部调用的gas效率更高，但不能在内部调用，可以被其他合约调用。
2. `private` vs `internal`：
   * private函数提供最高级别的封装，这意味着只有**同一个**合约可以调用它们。
   * internal函数允许在继承的合约中重用代码，这意味着派生合约也可以调用它们。

现在让我们使用一个名为`Base`的示例合约来展示这一点，在`./contracts/visibility.sol`中：

首先，让我们定义合约及其状态变量：
```solidity 
contract Base {
    function publicFunc() public pure returns (string memory) {
        return "这是public函数";
    }
    
    function privateFunc() private pure returns (string memory) {
        return "这是private函数";
    }
    
    function internalFunc() internal pure returns (string memory) {
        return "这是internal函数";
    }
    
    function externalFunc() external pure returns (string memory) {
        return "这是external函数";
    }
}
```

然后使用一个名为`Derived`的派生合约和一个名为`Consumer`的测试合约来测试可见性说明符的效果：
```solidity
contract Derived is Base {
    function test() public pure returns (string memory) {
      // public函数可以在内部和外部调用，所以派生合约可以调用它
        return publicFunc();         // 这将正常工作
        // return internalFunc();   // 这将正常工作
        // return privateFunc();    // 这将不能工作
        // return externalFunc();   // 这将不能工作
        
    }
}

contract Consumer {
    function test() public pure returns (string memory) {
        Base b = new Base();
        // 只能调用public和external函数
        
        // return b.publicFunc();    // 这将正常工作
        return b.externalFunc();     // 这将正常工作
        // return b.privateFunc();   // 这将不能工作
        // return b.internalFunc();  // 这将不能工作
    }
}
```

在这种情况下，
* `publicFunc`可以在外部和内部合约（包括派生合约）中调用，
* `privateFunc`只能在同一个合约内调用。
* `internalFunc`可以在同一个合约和派生合约中调用。
* `externalFunc`只能从合约外部调用。

Solidity有额外的`internal`和`external`关键字的原因是为了提供对函数可访问性的精细控制，并优化gas使用。

## 2. 状态可变性关键字

### `view` 
在Solidity中，view函数确实类似于其他语言（如Java）中的`readonly`。但在Solidity中，我们还必须考虑gas消耗。
* 它要求函数不修改合约的状态(state)。
* 从外部调用时不消耗gas，但从内部调用时消耗gas。

### `pure`
* 它规定了函数不读取或修改合约的状态(state)。`pure`函数的一个常见用例是对输入参数执行计算。
* 和`view`一样，从外部调用时不消耗gas，但从内部调用时消耗gas。

### `payable`
我们在前面的部分已经介绍过这一点，但值得再次提及。`payable`关键字允许函数接收以太币。
这对于需要接收以太币的函数来说是必要的，比如接受支付的函数。
> 注意：带有`payable`关键字的函数将自动接收以太币，但重要的是要检查收到的以太币数量并适当处理，以避免重入攻击

### 真实世界示例：钱包合约
```solidity
pragma solidity ^0.8.0;

contract Wallet {
    address public owner;
    
    constructor(){
        owner = msg.sender;
    }
    
    function deposit() public payable {
        require(msg.value > 0, "存款金额应大于0");
        // 不需要做任何事情，因为`payable`会自动让合约接受以太币
      // 最佳做法是检查余额
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function showFiatValue(uint256 amount, uint16 rate) public pure returns(uint256) {
        return amount * rate;
    }
}
```
在这个例子中，给出的`./contracts/Wallet.sol`：
* 由于我们需要`deposit`函数实际接收以太币，所以它需要有一个`payable`关键字。
* `getBalance`函数是一个`view`函数，因为它只读取合约的状态。
* `showFiatValue`函数是一个`pure`函数，因为它只对输入参数执行计算。

## 3. 函数修饰符
函数修饰符就像Java中的装饰器。它们用于修改Solidity中函数的行为。
函数修饰符最常见的用例之一是为函数添加访问控制。
在`Wallet.sol`中，我们可以添加一个`onlyOwner`修饰符来限制某些函数只能由合约所有者调用。比如我们有一个`withdraw`函数，我们只想让所有者能够调用它。

```solidity
contract Wallet {
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "只有所有者才能执行此操作");
        _;
    }
    
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "资金不足");
        payable(address(this)).transfer(amount);
    }
    // 合约的其余部分保持不变
    // ...
}
```

## 4. 函数重载
Solidity支持函数重载，允许多个具有相同名称但不同参数类型的函数。

这有点像Java，但在Solidity中，你不能有相同数量的参数但类型不同。

例如，我们可以在`Wallet`合约中添加一个`transfer`函数，可以进行单次转账和批量转账。

```solidity
contract Wallet {
    function transfer(address payable to, uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "资金不足");
        to.transfer(amount);
    }
    
    function transfer(address payable[] memory to, uint256[] memory amount) public onlyOwner {
        require(amount.length == to.length, "数组长度不匹配");
        for(uint i = 0; i < to.length; i++) {
            transfer(to[i], amount[i]);
        }
    }
    
    // 合约的其余部分保持不变
    // ...
}
```

