// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Algorithm {
    mapping(bytes1 => int) private symbolValues;
    constructor() {
        symbolValues["I"] = 1;
        symbolValues["V"] = 5;
        symbolValues["X"] = 10;
        symbolValues["L"] = 50;
        symbolValues["C"] = 100;
        symbolValues["D"] = 500;
        symbolValues["M"] = 1000;
    }

    //Binary Search
    function binarySearch(
        uint[] memory nums,
        uint target
    ) public pure returns (int) {
        uint left = 0;
        uint right = nums.length - 1;
        while (left <= right) {
            uint mid = (right - left) / 2 + left;
            uint num = nums[mid];
            if (num == target) {
                return int(mid);
            } else if (num > target) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return -1;
    }

    //Merge Sorted Array
    function mergeSortedArray(
        uint[] memory sort1,
        uint[] memory sort2
    ) public pure returns (uint[] memory) {
        uint[] memory result = new uint[](sort1.length + sort2.length);
        uint index = 0;
        uint j = 0;
        // sort1 元素肯定可以遍历完
        for (uint i = 0; i < sort1.length; i++) {
            for (; j < sort2.length; ) {
                if (sort2[j] > sort1[i]) {
                    result[index++] = sort2[j++];
                } else {
                    break;
                }
            }
            result[index++] = sort1[i];
        }

        // sort2元素未遍历完，需要补齐
        for (; j < sort2.length; j++) {
            result[index++] = sort2[j];
        }

        return result;
    }

    // 罗马数字转整数
    function romanToInt(string calldata s) public view returns (int) {
        bytes calldata sByte = bytes(s);
        int result;
        for (uint i = 0; i < sByte.length; i++) {
            int count = symbolValues[sByte[i]];
            if (i < sByte.length - 1 && count < symbolValues[sByte[i + 1]]) {
                result -= count;
            } else {
                result += count;
            }
        }

        return result;
    }

    uint16[13] intValues = [
        1000,
        900,
        500,
        400,
        100,
        90,
        50,
        40,
        10,
        9,
        5,
        4,
        1
    ];
    string[13] symbols = [
        "M",
        "CM",
        "D",
        "CD",
        "C",
        "XC",
        "L",
        "XL",
        "X",
        "IX",
        "V",
        "IV",
        "I"
    ];

    // 整数转罗马数字
    function intToRoman(uint num) public view returns (string memory) {
        string memory result;
        for (uint i = 0; i < intValues.length; i++) {
            while (num >= intValues[i]) {
                num -= intValues[i];
                result = string.concat(result, symbols[i]);
            }
            if (num == 0) {
                break;
            }
        }
        return result;
    }

    // 翻转字符串
    function reverse(string calldata str) public pure returns (string memory) {
        bytes calldata byteStr = bytes(str);
        bytes memory result = new bytes(byteStr.length);
        for (uint i = 0; i < byteStr.length; i++) {
            result[i] = byteStr[byteStr.length - 1 - i];
        }
        return string(result);
    }
}
