// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GuessTheSecretNumberChallenge} from "../../src/lotteries/GuessTheSecretNumberChallenge.sol";

contract GuessTheSecretNumberChallengeTest is Test {
    GuessTheSecretNumberChallenge challenge;

    receive() external payable {}

    function setUp() public {
        vm.deal(address(this), 2 ether);
        challenge = new GuessTheSecretNumberChallenge{value: 1 ether}();
    }

    function testBruteForce() public {
        bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
        
        // uint8 can only hold 256 in maximum, 
        //   we can try hash all of them to get answer.
        for (uint8 i = 0; i < 255; i++) {
            if (keccak256(abi.encodePacked(i)) == answerHash) {
                challenge.guess{value: 1 ether}(i);
                break;
            }
        }
        
        assertTrue(challenge.isComplete(), "not completed");
    }
}
