// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ISimpleStrategy {
    // 核心业务函数
    function invest(uint256 amount) external;
    function divest(uint256 amount) external;
    function totalAssets() external view returns (uint256);

    // 资产查询
    function asset() external view returns (IERC20);
}
