// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/lotteries/GuessTheNumberChallenge.sol";

contract GuessTheNumberChallengeTest is Test {
    GuessTheNumberChallenge public challenge;
    address testAccount;

    function setUp() public {
        testAccount = vm.addr(1);
        vm.deal(testAccount, 10 ether);
        vm.startPrank(testAccount);
        challenge = new GuessTheNumberChallenge{value: 1 ether}();
    }

    function testGuess() public {
        // we know the number already, it's simple
        challenge.guess{value: 1 ether}(42);
        assertTrue(challenge.isComplete());
        assertEq(testAccount.balance, 10 ether);
    }
}
