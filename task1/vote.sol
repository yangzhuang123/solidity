// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Vote {

    //一个mapping来存储候选人的得票数
    //一个vote函数，允许用户投票给某个候选人
    //一个getVotes函数，返回某个候选人的得票数
    //一个resetVotes函数，重置所有候选人的得票数

    mapping(address candidate => uint count) private candidateMap;
    address[] private  candidates;

    function vote(address  candidate) external    {
        if (candidateMap[candidate] == 0){
            candidates.push(candidate);
        }
        candidateMap[candidate]++;
    }

    function getVotes(address  candidate) public view returns(uint count){
        return candidateMap[candidate];
    }

    function resetVotes() external  {
         for (uint i = 0; i < candidates.length; i++) {
            candidateMap[candidates[i]] = 0;
        }
        delete candidates;
    }


}
