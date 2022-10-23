// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/lotteries/PredictTheBlockHashChallenge.sol";

contract PredictTheBlockHashChallengeTest is Test {
    PredictTheBlockHashChallenge public challenge;
    address testAccount;
    uint8 guess = 9;

    function setUp() public {
        testAccount = vm.addr(1);
        vm.deal(testAccount, 10 ether);
        vm.startPrank(testAccount);
        challenge = new PredictTheBlockHashChallenge{value: 1 ether}();
    }

    function testGuess() public {
        challenge.lockInGuess{value: 1 ether}(0);
        // blockhash(uint blockNumber) returns (bytes32): hash of the given block when blocknumber is one of the 256 most recent blocks; otherwise returns zero
        vm.roll(block.number + 258);
        challenge.settle();
        assertTrue(challenge.isComplete());
        assertEq(testAccount.balance, 10 ether);
    }
}
