// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../src/SimpleVault.sol";
import "../src/MockToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleVaultTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS); // Définir l'adresse du contrat HEVM pour l'accès aux fonctionnalités de vm

    SimpleVault private vault;
    MockToken private token;
    address private owner;
    address private user;

    function setUp() public {
        owner = address(this); // L'adresse de ce contrat de test sera le propriétaire du MockToken
        user = address(0x1); // Adresse fictive pour le test
        token = new MockToken(owner);
        vault = new SimpleVault(token);

        token.mint(user, 1000 ether); // Mint 1000 tokens pour l'utilisateur
        // Simuler que l'utilisateur approuve le vault à dépenser ses tokens
        vm.startPrank(user);
        token.approve(address(vault), 1000 ether); // L'utilisateur approuve le vault pour 1000 tokens
        vm.stopPrank();
    }

    function testDeposit() public {
        uint256 initialBalance = token.balanceOf(user);
        uint256 depositAmount = 100 ether;

        vm.startPrank(user);
        uint256 shares = vault.deposit(depositAmount, user);
        vm.stopPrank();

        assertEq(vault.balanceOf(user), shares, "User should receive shares");
        assertEq(token.balanceOf(user), initialBalance - depositAmount, "User token balance should decrease");
        assertEq(vault.totalAssets(), depositAmount, "Vault assets should increase");
    }

    function testWithdraw() public {
        uint256 depositAmount = 100 ether;
        vm.startPrank(user);
        uint256 shares = vault.deposit(depositAmount, user);
        uint256 withdrawn = vault.withdraw(depositAmount, user, user);
        vm.stopPrank();

        assertEq(withdrawn, shares, "Withdrawn shares should equal initial shares");
        assertEq(token.balanceOf(user), 1000 ether, "User should have initial token balance");
    }
}
