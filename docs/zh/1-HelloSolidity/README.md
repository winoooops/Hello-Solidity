# Solidity 简介
> Solidity 是一种**静态类型的、面向合约的**编程语言，专为开发在以太坊虚拟机（EVM）上运行的智能合约而设计。
> 它主要用于在各种区块链平台上实现智能合约，尤其是以太坊。

Solidity 的主要特点：
* 面向对象，类似于 C++ 和 Java。
* 静态类型，类似于 TypeScript 和 Java。
* 支持继承、库和用户自定义类型。

# 典型的 Solidity 项目架构
一个典型的 Solidity 项目通常包括以下组件：

* 合约：包含智能合约代码的核心 Solidity 文件（.sol）。
* 测试：通常使用 JavaScript 或 Solidity 编写，使用 Truffle 或 Hardhat 等框架。
* 迁移：用于将合约部署到各种网络的脚本。
* 前端：通常是与已部署合约交互的 Web 应用程序。
* 配置文件：用于开发环境、网络配置等。

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
├── truffle-config.js (或 hardhat.config.js)
└── package.json
```

# 基本 Solidity 合约示例
> 要编写、编译和运行 Solidity，请使用 https://remix.ethereum.org/

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

* 合约的开头通常包含许可信息
* `contract` 关键字用于声明新合约
* 声明变量时，使用以下格式：
    ```
    <类型> [可见性] [状态可变性] <名称> [= <初始值>];
    ```
* 声明函数时，遵循以下规则：
    ```
    function <名称>(<参数类型>) [可见性] [状态可变性] [returns (<返回类型>)] {
        // 函数体
    }
    ```
* 声明结构体（类似于 JavaScript 中的对象，但更加严格和静态类型化）：
    ```
    struct <名称> {
        <类型> <字段名>;
        // ... 更多字段
    }
    ```