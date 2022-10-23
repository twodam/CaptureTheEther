// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/warmup/DeployChallenge.sol";

contract DeployChallengeTest is Test {
    DeployChallenge public challenge;

    function setUp() public {
        challenge = new DeployChallenge();
    }

    function testDeploy() public {
        assertTrue(challenge.isComplete());
    }
}