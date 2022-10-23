// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/lotteries/GuessTheSecretNumberChallenge.sol";

contract GuessTheSecretNumberChallengeTest is Test {
    GuessTheSecretNumberChallenge public challenge;
    address testAccount;

    function setUp() public {
        testAccount = vm.addr(1);
        vm.deal(testAccount, 10 ether);
        vm.startPrank(testAccount);
        challenge = new GuessTheSecretNumberChallenge{value: 1 ether}();
    }

    function testGuess() public {
        bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
        uint8 n;
        // brute-force the secret number
        for(uint8 i = 0; i < 256; i++) {
            if (keccak256(abi.encodePacked(i)) == answerHash) {
                n = i;
                break;
            }
        }

        challenge.guess{value: 1 ether}(n);
        assertTrue(challenge.isComplete());
        assertEq(testAccount.balance, 10 ether);
        console.log(n);
    }
}
