// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "./MockToken.sol";

contract SimpleVault is ERC4626 {
    /**
     * @dev Crée un nouveau vault qui utilise MockToken comme asset sous-jacent.
     * Ce contrat agit comme un token ERC20 avec ses propres nom et symbole.
     * @param _token Adresse du MockToken utilisé comme asset sous-jacent.
     */
    constructor(MockToken _token)
        ERC4626(_token) // Seul le token sous-jacent est passé au constructeur d'ERC4626
        ERC20("SimpleVaultToken", "SVT") // Nom et symbole pour les parts du vault
    {}

    // Les fonctionnalités de base telles que deposit, withdraw, mint et redeem sont fournies par ERC4626.
}
