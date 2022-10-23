// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/lotteries/GuessTheRandomNumberChallenge.sol";

contract GuessTheRandomNumberChallengeTest is Test {
    GuessTheRandomNumberChallenge public challenge;
    address testAccount;

    function setUp() public {
        testAccount = vm.addr(1);
        vm.deal(testAccount, 10 ether);
        vm.startPrank(testAccount);

        challenge = new GuessTheRandomNumberChallenge{value: 1 ether}();
        // simulate new blocks
        vm.roll(block.number + 1);
    }

    function testGuess() public {
        // read the answer from the contract directly by loading the first slot
        uint8 answer = uint8(uint256(vm.load(address(challenge), 0)));
        challenge.guess{value: 1 ether}(answer);
        assertTrue(challenge.isComplete());
        assertEq(testAccount.balance, 10 ether);
    }
}
