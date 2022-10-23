// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DeployChallenge {
    // This tells the CaptureTheFlag contract that the challenge is complete.
    function isComplete() public pure returns (bool) {
        return true;
    }
}