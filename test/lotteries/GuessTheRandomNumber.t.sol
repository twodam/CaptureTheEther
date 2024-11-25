// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GuessTheRandomNumber} from "../../src/lotteries/GuessTheRandomNumber.sol";

contract GuessTheRandomNumberTest is Test {
    GuessTheRandomNumber challenge;

    receive() external payable {}

    function setUp() public {
        vm.deal(address(this), 1 ether);
        challenge = new GuessTheRandomNumber{value: 1 ether}();
    }

    function testReadingFromSlot() public {
        // we read answer from slot 0
        //   because it's only "private" to other contracts
        //   or external calls through standard function invocations.
        bytes32 slot = bytes32(uint256(0));
        bytes32 value = vm.load(address(challenge), slot);
        uint8 answer = uint8(uint256(value));
        vm.deal(address(this), 1 ether);
        challenge.guess{value: 1 ether}(answer);

        assertTrue(challenge.isComplete(), "not completed");
    }
}
