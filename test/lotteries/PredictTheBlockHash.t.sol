// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PredictTheBlockHash} from "../../src/lotteries/PredictTheBlockHash.sol";

contract PredictTheBlockHashTest is Test {
    PredictTheBlockHash challenge;

    receive() external payable {}

    function setUp() public {
        vm.deal(address(this), 1 ether);
        challenge = new PredictTheBlockHash{value: 1 ether}();
    }

    function testBlockHashNotAvailable() public {
        // hash of block beyond 256 will be 0
        vm.deal(address(this), 1 ether);
        challenge.lockInGuess{value: 1 ether}(0);
        vm.roll(vm.getBlockNumber() + 2 + 256);
        challenge.settle();

        assertTrue(challenge.isComplete(), "not completed");
    }
}
