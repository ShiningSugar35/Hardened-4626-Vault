// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SimpleStrategy.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/ISimpleStrategy.sol";

contract HardenedVault is ERC4626, Ownable {
    ISimpleStrategy public strategy;
    using SafeERC20 for IERC20;

    constructor(IERC20 _asset, string memory _vaultName, string memory _vaultSymbol, address _owner)
        ERC20(_vaultName, _vaultSymbol)
        ERC4626(_asset)
        Ownable(_owner)
    {}

    /***  @dev Allow the owner to set the strategy address. */
    function setStrategy(address _strategy) public onlyOwner {
        strategy = ISimpleStrategy(_strategy);
        IERC20(asset()).approve(_strategy, type(uint256).max);
    }

    /*** @dev Override the deposit function to invest assets into the strategy */
    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        uint256 shares = super.deposit(assets, receiver);
        if (address(strategy) != address(0)) {
            strategy.invest(assets);
        }
        return shares;
    }

    /*** @dev Override the withdraw function to divest assets from the strategy */
    function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {
        if (address(strategy) != address(0)) {
            strategy.divest(assets);
        }
        uint256 shares = super.withdraw(assets, receiver, owner);
        return shares;
    }
}
