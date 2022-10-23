// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/lotteries/PredictTheFutureChallenge.sol";

contract PredictTheFutureChallengeTest is Test {
    PredictTheFutureChallenge public challenge;
    address testAccount;
    uint8 guess = 9;

    function setUp() public {
        testAccount = vm.addr(1);
        vm.deal(testAccount, 10 ether);
        vm.startPrank(testAccount);
        challenge = new PredictTheFutureChallenge{value: 1 ether}();
    }

    function canSettle() internal returns (bool) {
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)))) % 10;
        if (answer == guess) {
            challenge.settle();
            return true;
        } else {
            return false;
        }
    }

    function testGuess() public {
        challenge.lockInGuess{value: 1 ether}(guess);
        // can only settle on future blocks
        vm.roll(block.number + 1);

        // keep trying until we can settle with the correct answer
        while(!canSettle()) {
            vm.roll(block.number + 1);
        }

        assertTrue(challenge.isComplete());
        assertEq(testAccount.balance, 10 ether);
    }
}
