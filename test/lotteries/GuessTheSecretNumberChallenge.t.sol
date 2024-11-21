// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GuessTheSecretNumberChallenge} from "../../src/lotteries/GuessTheSecretNumberChallenge.sol";

contract GuessTheSecretNumberChallengeTest is Test {
    receive() external payable {}

    function setUp() public {}

    function testSolutionOnchain() public {
        for (uint8 i = 0; i < 255; i++) {
            vm.deal(address(this), 2 ether);
            GuessTheSecretNumberChallenge challenge = new GuessTheSecretNumberChallenge{value: 1 ether}();
            challenge.guess{value: 1 ether}(i);
            
            if (challenge.isComplete()) {
                console.log("Answer is %s", i);
                break;
            }
        }
        
        assertEq(address(this).balance, 2 ether);
    }

    function testSolutionOffchain() public {
        bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
        vm.deal(address(this), 2 ether);
        GuessTheSecretNumberChallenge challenge = new GuessTheSecretNumberChallenge{value: 1 ether}();

        for (uint8 i = 0; i < 255; i++) {
            if (keccak256(abi.encodePacked(i)) == answerHash) {
                console.log("Answer is %s", i);
                challenge.guess{value: 1 ether}(i);
                break;
            }
        }
        
        assertTrue(challenge.isComplete());
    }
}
