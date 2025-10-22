// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

/*
合约包含以下标准 ERC20 功能：
balanceOf：查询账户余额。
transfer：转账。
approve 和 transferFrom：授权和代扣转账。
使用 event 记录转账和授权操作。
提供 mint 函数，允许合约所有者增发代币。
提示：
使用 mapping 存储账户余额和授权信息。
使用 event 定义 Transfer 和 Approval 事件。
部署到sepolia 测试网，导入到自己的钱包
*/
contract MyERC20 {
    mapping(address account => uint256) public _balances;
    mapping(address account => mapping(address spender => uint256)) public _allowances;
    uint8 public constant decimals = 18;
    uint256 public  _totalSupply;
    string public _name;
    string public _symbol;
    address public _owner;

    // 转账事件（记录代币转移）
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 授权事件（记录授权操作）
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _owner = msg.sender;
    }

     function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(from != address(0), "ERC20: transfer from zero address"); // 禁止从0地址转出
        require(to != address(0), "ERC20: transfer to zero address");     // 禁止向0地址转账
        require(_balances[from] >= amount, "ERC20: insufficient balance"); // 检查转出地址余额
        require(_allowances[from][msg.sender] >= amount, "ERC20: insufficient allowance"); // 检查授权额度
        
        _allowances[from][msg.sender] -= amount; // 扣除spender的剩余授权额度
        _balances[from] -= amount;             // 扣除转出地址余额
        _balances[to] += amount;               // 增加转入地址余额
        emit Transfer(from, to, amount);       // 触发Transfer事件
        return true;
    }

    function approve(address to, uint256 amount) public virtual returns (bool) {
        require(to != address(0), "ERC20: approve to zero address"); // 禁止向0地址转账
        require(_balances[msg.sender] >= amount, "ERC20: insufficient balance"); // 检查余额是否充足

        _allowances[msg.sender][to] = amount; // 记录授权额度
        emit Approval(msg.sender, to, amount); // 触发Approval事件
        return true;
    }

    function mint(address to, uint amount) external {
        require(msg.sender != _owner, "ERC20: address no premission");
        _balances[to] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        require(to != address(0), "ERC20: transfer to zero address"); // 禁止向0地址转账
        require(_balances[msg.sender] >= amount, "ERC20: insufficient balance"); // 检查余额是否充足

        _balances[msg.sender] -= amount * 10 ** decimals; // 扣除调用者余额
        _balances[to] += amount * 10 ** decimals; // 增加目标地址余额
        emit Transfer(msg.sender, to, amount); // 触发Transfer事件
        return true;
    }
}
