# 我知道这些都是概念，但你真的应该了解这些

> 这些内容基于我个人对智能合约、Solidity实现智能合约的方式以及以太坊虚拟机（EVM）的理解，
> 可能在某些方面存在不准确或不完整的地方。
> 
> 尽管我已尽力提供准确的信息，但区块链和智能合约领域复杂且发展迅速。
> 为获取最新和最全面的信息，我强烈建议参考Solidity的官方文档：
> * 英文版：[Introduction to Smart Contracts](https://docs.soliditylang.org/en/v0.8.26/introduction-to-smart-contracts.html#introduction-to-smart-contracts)
> * 中文版：[智能合约介绍](https://docs.soliditylang.org/zh/v0.8.19/introduction-to-smart-contracts.html)

## 1. 什么是区块链，它能做什么？

区块链是一种去中心化的分布式账本技术，它在多台计算机上记录交易，使得记录无法被追溯性地更改，除非同时更改所有后续区块并获得网络共识。

区块链的主要特点：

* 去中心化：没有单一权威控制区块链。
* 透明性：网络上的所有交易对任何人都是可见的。
* 不可变性：一旦数据被记录，就极难更改。
* 安全性：使用加密技术来保护交易和维护完整性。

区块链的作用：

* 实现无需中介的安全、透明交易
* 维护永久的、防篡改的交易记录
* 促进点对点网络中的信任
* 支持加密货币和去中心化应用（DApps）

## 2. 什么是智能合约，它为区块链增加了什么？

> 智能合约是一种自执行的合约，买卖双方之间的协议条款直接写入代码行。
> 代码及其中包含的协议存在于分布式的去中心化的区块链网络中。

### 智能合约类比：自动化咖啡店

想象一个完全通过区块链上的智能合约运行的咖啡店。它可能是这样运作的：

1. 菜单（合约条款）：
   * 传统：展示板显示咖啡种类和价格。
   * 智能合约：菜单是定义可用饮品、价格和条件（如大小、添加物）的代码。

2. 下单（启动合约）：
   * 传统：你向咖啡师说出你的订单。
   * 智能合约：你使用咖啡店的应用选择你的饮品。这触发了智能合约。

3. 支付（满足合约条件）：
   * 传统：你在获得咖啡之前或之后付款。
   * 智能合约：你的加密货币被保存在托管中。只有在条件满足时才释放支付。

4. 准备（合约执行）：
   * 传统：咖啡师根据订单制作你的咖啡。
   * 智能合约：自动化机器（或通过物联网设备验证的咖啡师）准备饮品。每个步骤都记录在区块链上。

5. 交付（合约履行）：
   * 传统：咖啡师叫你的名字；你取走你的咖啡。
   * 智能合约：你的订单完成被记录在区块链上。你通过应用确认收到，释放支付。

6. 定制（合约条件）：
   * 传统：你要求额外的浓缩或糖浆。
   * 智能合约：定制是编码的条件。添加它们会自动调整价格和准备说明。

7. 忠诚度计划（智能合约特性）：
   * 传统：你在卡片上收集印章以获得免费饮品。
   * 智能合约：你的购买自动记录，根据预定义的条件自动发放奖励（如免费饮品）。

8. 投诉（合约执行）：
   * 传统：如果你的订单错误，你向员工投诉。
   * 智能合约：对于问题（如错误订单、长等待时间）的预定义条件自动触发退款或补偿。

### 智能合约为区块链增加了什么：

新的可能性：智能合约使复杂的去中心化应用（DApps）和去中心化自治组织（DAOs）成为可能。

* 自动化：智能合约在预定义条件满足时自动执行。
* 精确性：智能合约以与传统合约相同的方式定义规则和后果，但还自动执行这些义务。
* 速度和效率：通过自动化流程，智能合约可以节省时间并减少对中介的需求。
* 信任：智能合约的去中心化执行消除了对中央权威或交易对手的信任需求。

### 智能合约为区块链增加了什么？

智能合约扩展了区块链的实用性，超越了简单的价值转移，
允许更复杂和有条件的交易。
它们构成了许多区块链应用的骨干，包括去中心化金融（DeFi）协议、非同质化代币（NFTs）等。

## 3. 智能合约的关键组件及其实现

> 在Solidity中，合约是一组代码（其函数）和数据（其状态），位于以太坊区块链上的特定地址。

Solidity中的典型智能合约通常包括以下关键功能组件：

### 1. 合约声明

定义合约及其名称。

```solidity
// 创建一个名为BaseToken的合约，继承ERC20的方法和属性
contract BaseToken {}
```

### 2. 状态变量

在区块链上存储合约的状态及其类型。

```solidity
contract BaseToken {
    // 定义一个名为totalSupply的状态变量，类型为`uint`（256位无符号整数）
    uint public totalSupply;
}
```

### 3. 构造函数

在合约部署时初始化合约。仅在合约创建时运行一次。

```solidity
contract BaseToken {
    uint256 public totalSupply;
    constructor(uint256 initSupply) {
        totalSupply = initSupply;
    }
}
```

### 4. 函数

* 这里定义了区块链上大多数操作/行为，使其具有交互性。
* 可以是`public`、`private`、`internal`或`external`

```solidity
contract BaseToken {
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    address public owner;
    
    function transfer(address recipient, uint256 amount) public {
        // 转账逻辑在这里
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply += amount;
        balances[to] += amount;
        owner = msg.sender; 
    }
}
```

### 5. 错误处理

就像任何其他语言一样，错误处理对Solidity来说至关重要。
Solidity提供了几种处理错误的机制：

#### `require(条件, 错误信息)`

* 用于在执行前验证输入和条件。如果条件为假，
* 它会撤销交易并返回错误信息。

```solidity
contract BaseToken {
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    address public owner; 
   
    function mint(address to, uint256 amount) public {
        // 检查函数调用者是否确实是区块链的所有者，如果为假，返回错误信息。
        require(msg.sender == owner, "只有所有者可以调用mint函数");
        totalSupply += amount;
        balances[to] += amount; 
    }  
}
```

#### `assert(条件)`

* 如果条件为假，它会撤销交易但消耗所有剩余的gas。
* 应该只用于检查**永远不应为假**的条件。

```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply = 100000;
    uint256 public maxSupply = 210000000;
    
    function burn(uint256 amount) public {
        require(balances[msg.sender] >= amount, "销毁数量超过余额");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        _assertInvariants();
    }
    
    // 递归的性质使这个函数极度消耗gas，不应在链上使用
    function _assertInvariants() internal view {
        // 断言totalSupply永远不超过maxSupply
        assert(totalSupply <= maxSupply);

        // 断言所有余额之和等于总供应量
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

#### `revert(错误信息)`

显式撤销当前交易并退还所有剩余的gas。

```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    
    function withdraw(uint256 amount) public {
        if (amount > balances[msg.sender]) {
            // 撤销交易，用户不必支付剩余的gas费用。
            revert("提款金额超过余额");
        }
        // ... 提款逻辑
    }
}
```

### 6. 修饰符

某些函数只允许在特定条件下执行，例如，只有合约所有者才能执行某些操作。

```solidity
contract BaseToken {
    // 访问控制的修饰符
    modifier onlyOwner() {
        require(msg.sender == owner, "只有所有者可以调用此函数");
        _;
    }
}
```

### 7. 事件

* 事件不是为了实现合约逻辑而设计的，它们只是提供通信方式。
* 事件不向调用者返回值。它们只是将数据记录到区块链的事件日志中。
* 事件只能由外部合约或服务（如Web DApps）发出。

```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Mint(address indexed to, uint256 amount);
    
    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] >= amount, "余额不足")
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

在这个例子中，`Transfer`和`Mint`事件在`transfer`和`mint`函数触发后被发出。
然后外部应用程序可以监听这些事件以更新它们的状态或触发操作。
事件在区块链上创建永久记录，可以在以后引用。

### 8. Fallback和Receive函数

> *以太币 ether（ETH）*是以太坊网络的原生加密货币。
> * 它用于转移价值和支付交易费用。
> * 它可以在账户之间发送和存储在合约中。
> * 以太币有几种面额：
    >   * *Wei*：以太币的最小单位：`1 Ether = 10^18 Wei`
>   * *Gwei*：通常用作gas价格：`1 Ether = 10^9 Gwei` 且 `1Gwei = 10^9 Wei`
>   * 其他不太常见的单位包括*Kwei*、*Mwei*、*Szabo*和*Finney*。
>
> 另一方面，*Gas*是衡量在以太坊网络上执行操作所需计算努力的单位。你可以将gas视为街机游戏中的能量代币
> * Gas价格以Gwei/gas表示，可能根据网络需求而波动。
> * 总交易费用计算为`使用的Gas * Gas价格`，例如，
    > 如果一个交易使用21,000 gas，而gas价格是20 Gwei，那么费用将是21,000 × 20 Gwei = 420,000 Gwei = 0.00042 ETH

#### `fallback`

Solidity中的`fallback`函数是一个特殊函数，只在两种情况下执行：
1. 当调用合约上不存在的函数（合约上没有的意外函数）时。
2. 当*Ether*被发送到合约**带有数据**（非空calldata）时。在这种情况下，它需要声明为`payable`以接受*Ether*

* `fallback`没有参数，也不返回任何内容。
* 当被另一个合约调用时，它限制为2,300 gas（为防止安全问题）。

#### `receive`

当*以太币*被发送到合约而没有任何数据时，专门调用`receive`。
* 它必须声明为`payable`
* 如果没有定义`receive`但存在可支付的`fallback`函数，则会调用`fallback`函数

### 9. 继承

它还能够继承其他合约的属性和方法（类似于类继承）。
* 使用`is`关键字进行继承
* 就像JavaScript一样，`super`用于在被重写的函数中调用基本实现
* 继承的合约可以访问基本合约的非私有属性

#### `virtual`

在基本合约中对函数应用`virtual`允许它在派生合约中被重写。

> 始终对基本合约中你打算允许重写的函数使用`virtual`。

```solidity
contract BaseToken {
    mapping(address => uint256) public balances;
    
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    // 使用`virtual`允许重写
    function transfer(address recipient, uint256 amount) public virtual {
        require(balances[msg.sender] >= amount, "余额不足");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }
}
```

#### `override`

显式重写基本合约中的函数。
应用于派生合约中重写基本合约函数的函数。

> 重写基本合约中的函数时必须始终使用`override`, 重写函数时省略`override`将导致编译错误。

```solidity
contract NewPepeToken is BaseToken {
    string public name = "New Pepe";
    string public symbol = "NPEPE";
    uint8 public decimals = 18;

    uint8 public burnRate = 1;

    constructor(uint256 initSupply) BaseToken(initSupply) {
       // 如果需要，可以进行额外的合约初始化
    }

    /*
     * "转账时销毁"：对代币供应创造通缩压力
     * 在每次交易中，从totalSupply中销毁1%的转账金额
    */
    function transfer(address recipient, uint256 amount) public override {
        require(balances[msg.sender] >= amount, "余额不足");

        uint256 burnAmount = amount * burnRate / 100;
        uint256 transferAmount = amount - burnAmount;

        balances[msg.sender] -= amount;
        balances[recipient] += transferAmount;

        super.burn(burnAmount);

        emit Transfer(msg.sender, recipient, transferAmount);
        emit Transfer(msg.sender, address(0), burnAmount); // 销毁就是转移到地址0
        emit Burn(msg.sender, burnAmount);
    }

    // 带访问控制的铸造函数
    function mint(address to, uint256 amount) public onlyOwner override  {
       super.mint(to, amount);
    }

    // 销毁函数
    function burn(uint256 amount) public override  {
        super.burn(amount);
    }

    function setBurnRate(uint8 targetRate) public {
       require(targetRate <= 10, "销毁率不能超过10%。");
       burnRate = targetRate;
    }
}
```

在这个例子中，通过继承`BaseToken`，`NewPepeToken`获得了标准代币功能的坚实基础，同时添加了自己的独特特性，
特别是转账时销毁机制，同时仍然能够编写自己的实现。

## 4. 理解以太坊虚拟机（EVM）

### 什么是EVM？

*以太坊虚拟机(EVM)* 是以太坊中智能合约的运行时环境。
它是一个图灵完备的、基于栈的虚拟机，用于执行字节码。每个以太坊节点都运行一个EVM实现，
使它们能够执行相同的指令。

想象EVM为一个巨大的、全球性的游乐场：
* **游乐场**：这就是EVM本身，一个任何人都可以来玩耍（执行他们的代码）的空间。
* **游乐场规则**：就像游乐场有安全和公平游戏的规则，EVM有每个人都必须遵守的规则（其协议）。
* **通用设计**：无论你在世界上的哪个地方，这个游乐场看起来和工作方式都完全相同，就像EVM在所有以太坊节点上提供一致的环境一样。

在这个游乐场类比中，智能合约就像游乐设备：
* **滑梯和秋千**：不同类型的智能合约服务于不同的目的，就像各种游乐设备一样。
* **需要组装**：在将设备放入游乐场之前，需要根据游乐场的规格进行组装（编译成字节码）。
* **使用说明**：一旦安装完成，任何人都可以根据其设计使用设备（与合约交互）。

### EVM如何工作

1. 合约部署：
    * Solidity代码被编译成EVM字节码。
    * 字节码被部署到以太坊网络。
2. 交易执行：
    * 一个交易触发合约执行。
    * EVM加载合约的字节码。
    * 逐条执行指令。
3. 状态变更：如果执行成功，状态变更被记录在区块链上。
4. Gas消耗：
    * 每个操作消耗一定量的gas。
    * 如果gas用尽，执行停止并且变更被撤销。

### EVM的目的

* 智能合约执行：为执行智能合约代码提供安全、隔离的环境。
* 确定性执行：确保相同的输入在所有节点上始终产生相同的输出，这对于达成共识至关重要。
* 去中心化：通过在整个以太坊网络上提供一致的执行环境，实现去中心化应用。

### EVM的主要特性

* **基于栈**：使用后进先出（LIFO）栈进行操作。
* **Gas机制**：使用"gas"来衡量计算成本并防止无限循环。
* **操作码**：有一组执行特定操作的字节码指令（操作码）。
* **数据存储**：*以太坊虚拟机*有三个区域可以存储数据
    * 栈：用于临时存储
    * 内存：在交易之间重置的易失性内存
    * 存储：合约状态变量的持久存储

> 你可以在[这里](./DATA_STORAGE.md)找到更多关于数据存储的信息

### 以太坊消息调用

想象以太坊是一座大办公楼，每个智能合约都是有自己办公室的员工。
消息调用就像这栋楼的内部通信系统。合约（员工）使用消息调用相互通信或发送以太币。

每个消息调用包含：
* 谁在调用（*source*）
* 他们在调用谁（*target*）
* 他们在说什么（*data payload*）
* 他们发送的任何金钱（*Ether*）
* 通话的能量（*gas*）
* 他们听到的回复（*return data*）

> 你可以在[这里](./MESSAGE_CALLS.md)找到更多关于消息调用的信息





