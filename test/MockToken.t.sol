// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MockToken.sol";  

contract MockTokenTest is Test {
    MockToken token;
    address deployer;

    function setUp() public {
        deployer = address(this); // Set the deployer as the test contract itself
        token = new MockToken(deployer); // Deploy a new MockToken with deployer as the initial owner
    }

    function testInitialBalance() public {
        // Since no tokens are minted in the constructor, we need to mint them first
        uint expectedInitialBalance = 1000 * 10 ** 18; // Adjust according to your token decimals
        token.mint(deployer, expectedInitialBalance); // Mint tokens to deployer
        assertEq(token.balanceOf(deployer), expectedInitialBalance, "Initial balance should be correctly minted");
    }

    function testTransfer() public {
        // Test transferring tokens
        address recipient = address(0x1);
        uint amount = 100 * 10 ** 18; // Adjust according to your token decimals
        token.mint(deployer, amount); // Ensure deployer has enough tokens to transfer

        token.transfer(recipient, amount); // Execute transfer
        assertEq(token.balanceOf(recipient), amount, "Recipient should receive the correct amount");
    }

    function testFailTransferExceedsBalance() public {
        // This test is expected to fail
        address recipient = address(0x2);
        uint amount = 1100 * 10 ** 18; // More than possible since no minting here

        token.transfer(recipient, amount); // This should fail
    }
}
