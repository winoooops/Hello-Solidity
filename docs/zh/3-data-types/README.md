# Solidity数据类型：与TypeScript的比较

> Solidity，与TypeScript类似，是一种静态类型语言，这意味着变量类型需要显式声明。
> 这与JavaScript的动态类型不同。理解这些差异对于从Web2转向Solidity开发的开发者来说至关重要。

> 注意： 在本文档中涉及`public`,`internal`等的关键词将在下一个章节中详细说明。

## 1. 布尔值
- Solidity: `bool`
- JavaScript/TypeScript: `boolean`

两种语言都使用`true`和`false`。用法非常相似：

```typescript
// TypeScript
let isActive: boolean = true;
```

```solidity
// Solidity
bool isActive = true;
```

## 2. 整数
Solidity提供两种主要类别的整数类型：

* 无符号整数（uint）：这些整数从0开始，只能表示非负数。
* 有符号整数（int）：这些整数可以表示正数和负数。

### 无符号整数
* 范围：`uint8`，`uint16`，`uint24`，...，`uint256`
* 上限是2^n - 1，其中n是位数。例如，`uint8`的范围是0到2^8 - 1。
* 所有无符号整数都从0开始

```solidity
uint8 smallPositive = 0;  // 任何uint的最小值
uint8 maxUint8 = 255;     // uint8的最大值 (2^8 - 1)
uint256 maxUint = 115792089237316195423570985008687907853269984665640564039457584007913129639935;  // uint256的最大值 (2^256 - 1)
```

### 有符号整数

* 范围：`int8`，`int16`，`int24`，...，`int256`
* 可以表示正数和负数
* 范围是从-2^(n-1)到2^(n-1) - 1，其中n是位数

```solidity
int8 minInt8 = -128;   // int8的最小值 (-2^7)
int8 maxInt8 = 127;    // int8的最大值 (2^7 - 1)
int256 minInt = -57896044618658097711785492504343953926634992332820282019728792003956564819968;  // int256的最小值 (-2^255)
int256 maxInt = 57896044618658097711785492504343953926634992332820282019728792003956564819967;   // int256的最大值 (2^255 - 1)
```

### 与JavaScript/TypeScript的主要区别

1. **无符号整数**：JavaScript/TypeScript没有原生的无符号整数类型。JavaScript中的所有数字都是双精度64位浮点数。
   ```javascript
   // JavaScript - 没有原生的无符号整数
   let num = 42;  // 这可能是正数、负数或零
   ```
   
   ```solidity
    // Solidity
    uint8 num = 42;  // 这只能是0或正数，最大到255    
   ``` 
2. **显式大小**：在Solidity中，你必须明确选择整数的大小，这会影响其范围和gas消耗。
3. **无隐式转换**：Solidity不允许有符号整数和无符号整数之间的隐式转换，以防止意外行为。
   ```solidity
   uint8 a = 5;
   int8 b = -1;
   // uint8 c = a + b;  // 这会导致编译错误
   int8 c = int8(a) + b;  // 这是有效的，c的值为4 
   ```

## 3. 地址
> `address`：不能直接接收以太币。如果你试图向普通地址发送以太币，交易将失败。
> 
> `address payable`：可以接收以太币。这种类型专门用于处理以太币转账。

这是以太坊和Solidity特有的。`address`和`address payable`都被分类为值类型，而不是引用类型。

主要区别是`address`**不能**用于接收和发送*以太币*，而`address payable`**可以**。

```solidity
// Solidity
address owner = 0x123...;
address payable recipient = payable(0x456...);
```

在JavaScript/TypeScript中，以太坊地址通常作为字符串处理，并使用库或自定义函数进行验证。
```typescript
// TypeScript
let owner: string = "0x123...";
```

#### 可用方法

`address`：
* `balance`：检查地址的余额
* `code`：获取地址的代码（对于合约）

`address payable`：具有address的所有方法，外加：
* `transfer(uint256 amount)`：向地址发送以太币，失败时抛出异常
* `send(uint256 amount)`：向地址发送以太币，返回布尔值（成功返回true，失败返回false）
* `call{value: amount}("")`：向地址发送以太币，返回布尔值（成功返回true，失败返回false）, 推荐使用此方法。

```solidity
contract CollegeFund {
    address public admin;
    uint256 public savingBalance;
    uint256 public checkingBalance;

    modifier onlyAdmin() {
        require(msg.sender == admin, "只有管理员允许执行此操作");
        _;
    }

    constructor() payable {
        require(msg.value > 0, "需要初始存款");
        admin = msg.sender;
        deposit(msg.value);
    }

    function deposit(uint256 amount) public payable {
        require(msg.value == amount, "存款金额不正确");
        checkingBalance += amount / 10;
        savingBalance += amount - amount / 10;
    }

    function withdrawFromChecking(uint256 amount, address payable wallet) public onlyAdmin {
        require(amount <= checkingBalance, "余额不足");
        checkingBalance -= amount;
        // !重要：Solidity只支持从合约转出以太币，这意味着合约不能操作外部资源如钱包地址
        wallet.transfer(amount);
    }

    function transferToChecking(uint256 amount) public onlyAdmin {
        require(amount <= savingBalance, "余额不足");
        savingBalance -= amount;
        checkingBalance += amount;
    }

    receive() external payable {
        deposit(msg.value);
    }
}
```

## 4. 字符串和字节
Solidity有两种处理字符串数据的类型：`string`和`bytes`。

### `string`

```solidity
string public name = "Alice";
```

* 用于UTF-8编码的数据。
* 动态大小，但操作可能会很昂贵。
* 内置操作有限（没有原生的连接或长度操作）。

### `bytes`

* `bytes`类似于string，但允许长度和索引访问操作。
* `bytes1`到`bytes32`是固定大小的字节数组。
* 对于某些操作来说，比string更节省gas。

```solidity
// Solidity
bytes32 hash = 0x123...;
bytes memory dynamicBytes = new bytes(10);
```

在JavaScript/TypeScript中，你通常使用十六进制字符串并在需要时将其转换为字节数组。
```typescript
// TypeScript
let hash: string = "0x123...";
let dynamicBytes: Uint8Array = new Uint8Array(10);
```

## 5. 数组

* Solidity中的数组可以是固定大小或动态的，可以包含任何类型，包括`struct`和`mapping`。
* *Solidity*区分存储和内存数组；TypeScript没有这个概念。
* Solidity中的数组操作有gas成本，所以使用时要注意效率。

> 内存数组必须有固定大小。

### 数组方法
* `.push()`：向动态数组末尾添加一个元素。
* `.pop()`：从动态数组末尾移除一个元素。
* `.length`：返回数组的当前长度。

### 固定大小数组

```solidity
uint[5] public fixedArray = [1, 2, 3, 4, 5];
bytes32[3] public fixedByteArray;

function memoryArray(uint[] memory _arr) public pure returns (uint[] memory) {
    uint[] memory newArray = new uint[](5); // 在内存中必须指定大小
    for (uint i = 0; i < 5; i++) {
        newArray[i] = _arr[i];
    }
    return newArray;
}

```
* 大小在声明时确定，不能更改。
* 比动态数组更节省gas。
* 自动用默认值初始化（uint为0，bytes32为空字节等）。

### 动态数组
> Solidity不支持从外部函数返回动态数组。
> Solidity不支持嵌套的动态数组。

```solidity
uint[] public dynamicArray;
bytes32[] public dynamicByteArray;
```
* 大小可以在声明后改变。
* 更灵活但消耗更多gas。
* 使用前必须初始化。

> 如果数据集很大且长度事先不知道，考虑使用映射或其他数据结构。

## 6. 映射
> 对于大数据集的查找，映射比数组更节省gas。

Solidity中的映射是哈希表，它们被虚拟初始化，使得每个可能的键都存在并映射到一个值。

```solidity
mapping(address => uint) public balances;
mapping(uint => mapping(uint => bool)) public grid;
```

* Solidity中的映射不能被迭代，也不存储键的数量，这意味着你不能检查键是否存在，也不能获取键或值的列表。
* 没有长度或"空"的概念：所有键都存在，如果未设置则返回默认值。

```solidity
contract MappingExample {
    mapping(address => uint) public balances; // 存储每个地址的余额
    mapping(address => mapping(address => bool)) public isAllowed; // 确定一个地址是否被允许花费另一个地址的资金

    function updateBalance(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }

    function setAllowed(address spender) public {
        isAllowed[msg.sender][spender] = true;
    }

    function getBalance(address account) public view returns (uint) {
        return balances[account];
    }
}
```

## 7. 结构体
Solidity中的结构体允许你创建将相关数据组合在一起的自定义类型。

* 嵌套：你可以在其他结构体中嵌套结构体，但要小心循环引用。
* 有两种存储结构体的方式：在`memory`中或在`storage`中。
    * 存储结构体存储在区块链上。
    * 内存结构体是临时的，只在函数执行期间存在。

```solidity
contract ClientBook {
    struct Person {
        string name;
        bool isVip;
        address walletAddress;
    }

    Person[] public clients;

    function addClient(string memory name, bool isVip, address walletAddress) public {
        clients.push(Person(name, isVip, walletAddress));
    }

    function getClientInfo(address _address) public view returns (Person memory) {
        for (uint256 i = 0; i < clients.length; i++) {
            if (clients[i].walletAddress == _address) {
                return clients[i];
            }
        }
        return Person("", false, address(0));
    }
}
```

## 8. 枚举

* Solidity枚举经常用于链上状态管理；
* 语法与TypeScript枚举非常相似。

```solidity
contract BaseContract {
    // 使用枚举将uint 0, 1, 2转换为Pending, Active和Inactive    
    enum State { Pending, Active, Inactive }

    State public contractState;

    function setState(State _state) public {
        contractState = _state;
    }

    function getState() public view returns (State) {
        return contractState;
    }    
}
```

