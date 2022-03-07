// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuilding {
    function mint(address player) external payable returns(uint256);
}
