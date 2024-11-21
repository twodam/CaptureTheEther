// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract GuessTheRandomNumber {
    uint8 answer;

    constructor() payable {
        require(msg.value == 1 ether);
        answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether, "pay to guess only");

        if (n == answer) {
            payable(msg.sender).transfer(2 ether);
        }
    }
}