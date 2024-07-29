# Solidity 中的错误和错误处理

> 在 Solidity 中，错误是一种表示智能合约执行过程中发生了意外或无效情况的方式。
> Solidity 使用**状态回滚**异常来处理错误。这种异常会撤销当前调用（及其所有子调用）中对状态的所有更改，并向调用者标记一个错误。
> 错误处理是指用于优雅处理这些错误的机制和实践。

当异常发生在子调用（例如，函数调用）中时，错误会沿调用栈向上传播（冒泡），直到达到顶层函数。
如果错误未被捕获和处理（未在 `try/catch` 中捕获），交易将被回滚，对状态的所有更改都将被撤销。

```solidity
contract A {
    function foo() public {
        B b = new B();
        b.bar(); // 如果 bar() 抛出异常，它将冒泡到 foo()，foo() 将回滚交易。
    }   
}

contract B {
    function bar() public {
        revert("休斯顿，我们遇到问题了。");
    }
}
```

在上面的例子中，错误栈如下：`bar() -> foo() -> 顶层函数`。如果错误未在 `foo()` 中捕获，交易将被回滚，对状态的所有更改都将被撤销。

然而，对于低级调用（例如 `call`、`delegatecall`、`staticcall`），错误不会沿调用栈向上传播。

相反，会检查调用的返回值来确定调用是否成功。如果调用不成功，函数返回 `false`，错误必须手动处理。

```solidity
contract SimpleBank {
    mapping(address=>uint256) public accounts;
    
    function deposit() public payable {
        accounts[msg.sender] += msg.value;
        (bool isSuccess,) = msg.sender.call{value: msg.value}(""); // 如果调用失败，isSuccess 为 false
        require(isSuccess, "向 msg.sender 发送以太币失败"); // 必须手动处理错误
    }
}
```

## `assert` 与 **Panic**
> `assert` 应该只在内部使用，用于检查不应该为假的不变量和条件。
> 它用于表示出现了严重错误，合约处于不一致状态。

如果条件为假，`assert` 函数会创建 `Panic(uint256)` 类型的**错误**。

* 它应该只用于内部错误检查
* 正常运行的合约永远不应触发 `Panic`（`assert` 条件应始终为真）。

```
Panic 错误代码：
- 0x00：通用的编译器插入的恐慌
- 0x01：错误的断言
- 0x11：算术溢出/下溢
- 0x12：除以零或取模为零
- 0x21：无效的枚举转换
- 0x22：不正确的存储字节数组编码
- 0x31：对空数组执行 .pop()
- 0x32：数组访问越界
- 0x41：内存分配过多或数组过大
- 0x51：调用未初始化的内部函数
```

## `require`与**Error**
> `require` 用于验证用户输入和合约正确执行所必须满足的条件。
> 如果条件为假，它将生成一个通用错误消息。

`require` 用于检查外部条件。它有 3 个重载：
* `require(bool)`：不带任何数据回滚交易。
* `require(bool, string)`：使用 `Error(string)` 回滚交易。
* `require(bool, error)`：使用自定义的用户提供的 `error` 回滚交易。

错误也可能在其他场景中触发，例如：

* 失败的 `.transfer()` 调用
* 未正确完成的合约创建
* 在非 payable 函数中接收以太币

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Sharer {
    function sendHalf(address payable addr) public payable returns (uint balance) {
        require(msg.value % 2 == 0, "需要偶数值。"); // 检查外部条件 
        uint balanceBeforeTransfer = address(this).balance;
        addr.transfer(msg.value / 2);
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2); // 检查内部状态是否一致
        return address(this).balance; 
    }
}
```

## 使用 `require` 或 `revert` 的**自定义错误**
如果你想为错误消息提供更多上下文，可以使用带有自定义错误消息的 `require` 或 `revert`。

它还提供了更加**节省 gas** 的错误处理，因为错误消息不会存储在区块链上。

```solidity
// 在 ./contracts/6/SimpleWire.sol 中

error InsufficientBalance(uint256 available, uint256 required);

contract SimpleWire {
    mapping(address => uint256) public balances;
    
    function deposit() external payable {
        require(msg.value > 0, "存款金额必须大于 0");
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

## 错误处理中的 Gas 效率
> 以下结果由 0xAA 使用 Remix IDE 和 0.8.17 编译器版本进行测试，您可以在 [WTF-Solidity](https://github.com/AmazingAng/WTF-Solidity/tree/main/15_Errors) 中找到更多详情
> 
> "我们可以看到，（自定义）error 消耗的 gas 最少，其次是 `assert`，而 `require` 消耗的 gas 最多！因此，`error` 不仅能够告知用户错误消息，还能节省 gas。"

您也可以在 Remix 中创建自己的测试文件，使用这样的代码片段来验证大致的 gas 消耗情况

> `require` 不带消息比带消息消耗更多 gas 的原因是错误消息存储在区块链中，这会消耗更多 gas。

```solidity
error ErrorMathInvalid(string msg);

contract testErrorGasConsumption {
    function testAssert() external pure { 
        assert(5 < 10); // 估计 gas 消耗：145
    }

     function testCustomErrorWithRevert() external pure{
        if(5 > 10) {
            revert ErrorMathInvalid("必须遵守数学规则");  // 估计 gas 消耗：170
        }
    }

    function testRequireWithMessage() external pure {
        require(5<10, "必须遵守数学规则");  // 估计 gas 消耗：189
    }

    function testRequireWithoutMessage() external pure {
        require(5 < 10);  // 估计 gas 消耗：211 
    }
}
```
