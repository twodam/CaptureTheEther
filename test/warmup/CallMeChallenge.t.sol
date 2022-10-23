// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/warmup/CallMeChallenge.sol";

contract CallMeChallengeTest is Test {
    CallMeChallenge public challenge;

    function setUp() public {
        challenge = new CallMeChallenge();
    }

    function testCallMe() public {
        challenge.callme();
        assertTrue(challenge.isComplete());
    }
}