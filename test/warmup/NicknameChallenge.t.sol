// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/warmup/NicknameChallenge.sol";

contract NicknameChallengeTest is Test {
    CaptureTheEther public cte;
    NicknameChallenge public challenge;
    address public player;

    function setUp() public {
        player = vm.addr(1);
        vm.startPrank(player);
        cte = new CaptureTheEther();
        challenge = new NicknameChallenge(address(cte), player);
    }

    function testNickname() public {
        cte.setNickname("twodam");
        assertTrue(challenge.isComplete());
    }
}