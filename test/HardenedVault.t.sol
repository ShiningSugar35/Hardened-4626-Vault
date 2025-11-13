// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/forge-std/src/Test.sol";
import "src/HardenedVault.sol";
import "src/SimpleStrategy.sol";
import "./mocks/MockERC20.sol";

contract HardenedVaultTest is Test {
    // TODO: 1. 声明 HardenedVault, SimpleStrategy, 和 MockERC20 (asset)
    HardenedVault vault;
    SimpleStrategy strategy;
    MockERC20 asset;

    function setUp() public {
        ///@dev deploy MockERC20 (asset)
        asset = new MockERC20("Mock Asset", "MA");
        ///@dev deploy HardenedVault
        vault = new HardenedVault(IERC20(address(asset)), "Hardened Vault", "HVLT", address(this));
        ///@dev deploy SimpleStrategy
        strategy = new SimpleStrategy(address(asset), address(vault));
        ///@dev set the strategy for the vault
        vault.setStrategy(address(strategy));
    }

    /*** @dev Test setting the strategy in the HardenedVault */
    function test_SetStrategy() public {
        assertEq(address(vault.strategy()), address(strategy), "Strategy address should be set correctly");
        assertEq(vault.owner(), address(this), "Vault owner should be the deployer");
    }
}
