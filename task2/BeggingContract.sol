// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
创建一个名为 BeggingContract 的合约。
合约应包含以下功能：
一个 mapping 来记录每个捐赠者的捐赠金额。
一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
一个 withdraw 函数，允许合约所有者提取所有资金。
一个 getDonation 函数，允许查询某个地址的捐赠金额。
使用 payable 修饰符和 address.transfer 实现支付和提款。

捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。
**/

contract BeggingContract is Ownable {
    //来记录每个捐赠者的捐赠金额
    mapping(address donor => uint amount) private _donations;
    // 捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
    event Donation(address indexed donor, uint256 amount, uint256 timestamp);
    // 提取事件
    event WithDraw(address indexed owner, uint256 amount, uint256 timestamp);
    // 捐款截止时间
    uint256 public donationEndTime;
    // 捐款最多的三个地址
    address[3] private topDonors;

    // 构造函数
    constructor() Ownable(msg.sender) {
         donationEndTime = block.timestamp + 3 days;
    }

    // 捐款
    function donate() public payable {
        uint256 donation = msg.value;
        require(donation > 0, "Donation amount must be greater than 0");
        // 时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。
        require(block.timestamp < donationEndTime, "Donation period has ended");
        _donations[msg.sender] += donation;
        updateTopDonnors(msg.sender);
        emit Donation(msg.sender, msg.value, block.timestamp);
    }

    function updateTopDonnors(address donor) private{
        uint256 amount = _donations[donor];
        bool isTopDonor = false;
        // 初始化前三名捐款者
         for (uint256 i = 0; i < 3; i++) {
            if (topDonors[i] == donor) {
                isTopDonor = true;
                break;
            }
            if (topDonors[i] == address(0)) {
                topDonors[i] = donor;
                return;
            }
        }

        // 无需删除其他捐款者
        if (isTopDonor) {
            return;
        }

        // 更新前三名捐款者
        for (uint256 i = 0; i < 3; i++) {
            if (amount > _donations[topDonors[i]]) {
                for (uint256 j = 2; j > i; j--) {
                    topDonors[j] = topDonors[j - 1];
                }
                topDonors[i] = donor;
                break;
            }
        }
    }

    // 允许合约所有者提取所有资金
    function withdraw() external payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "no balance!");

        // 提取资金：使用transfer向所有者转账
        payable(owner()).transfer(balance);
        emit Donation(owner(), balance, block.timestamp);
    }

    //允许查询某个地址的捐赠金额
    function getDonation(address _addr) public view returns (uint) {
        return _donations[_addr];
    }

    // 获取捐款最多的三个地址
    function getTopDonors() public view returns (address[3] memory) {
        return topDonors;
    }
}
