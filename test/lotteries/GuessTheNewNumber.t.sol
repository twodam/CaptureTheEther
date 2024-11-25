// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GuessTheNewNumber} from "../../src/lotteries/GuessTheNewNumber.sol";

contract GuessTheNewNumberTest is Test {
    GuessTheNewNumber challenge;

    receive() external payable {}

    function setUp() public {
        vm.deal(address(this), 1 ether);
        challenge = new GuessTheNewNumber{value: 1 ether}();
    }

    function testDirectCalculation() public {
        // this call is from a Contract
        //   which share same block infos.
        //   so we can just calculate the answer to "guess".
        // we can deploy a proxy contract to do this
        //   if not within foundry test.
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
        vm.deal(address(this), 1 ether);
        challenge.guess{value: 1 ether}(answer);

        assertTrue(challenge.isComplete(), "not completed");
    }
}
