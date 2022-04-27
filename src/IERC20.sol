// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
interface IERC20{
    function balanceOf(address owner) external view returns (uint);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint value) external returns (bool);
}