// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract PredictTheBlockHash {
    address guesser;
    bytes32 guess;
    uint256 settlementBlockNumber;

    constructor() payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function lockInGuess(bytes32 hash) public payable {
        require(guesser == address(0), "someone joined before you");
        require(msg.value == 1 ether, "pay 1 eth to guess");

        guesser = msg.sender;
        guess = hash;
        settlementBlockNumber = block.number + 1;
    }

    function settle() public {
        require(msg.sender == guesser, "settler has to be same as guesser");
        require(block.number > settlementBlockNumber, "settle too soon");

        bytes32 answer = blockhash(settlementBlockNumber);

        guesser = address(0);
        if (guess == answer) {
            payable(msg.sender).transfer(2 ether);
        }
    }
}
