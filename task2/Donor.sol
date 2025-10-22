// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Donor {
    error CallFailed(); // 用call发送ETH失败error

    function callETH(address payable _to, uint256 amount) external payable {
        // 处理下call的返回值，如果失败，revert交易并发送error
        (bool success, ) = _to.call{value: amount}("");
        if (!success) {
            revert CallFailed();
        }
    }
}
