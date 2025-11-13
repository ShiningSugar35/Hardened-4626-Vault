// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/ISimpleStrategy.sol";

contract SimpleStrategy is Ownable, ISimpleStrategy {
    using SafeERC20 for IERC20;

    IERC20 public asset;

    constructor(address _asset, address _owner) Ownable(_owner) {
        asset = IERC20(_asset);
    }

    /*** @dev The fund manager of the vault */
    function invest(uint256 amount) external onlyOwner {
        asset.safeTransferFrom(msg.sender, address(this), amount);
    }

    function divest(uint256 amount) external onlyOwner {
        asset.safeTransfer(msg.sender, amount);
    }

    function totalAssets() external view returns (uint256) {
        return asset.balanceOf(address(this));
    }
}
