// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Helper functions OpenZeppelin provides.
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

import "./libraries/Base64.sol";
import "./interface/Building.sol";

// Helper functions OpenZeppelin provides.

contract Lumberjack is ERC721URIStorage, Ownable, Building {
    uint256 private constant INITIAL_PRICE = 1;
    uint256 private constant ININTAL_UPGRADE_DELAY = 1 minutes;
    uint256 private constant INITIAL_RESOURCE_DELAY = 1 minutes;

    struct LumberjackModel {
        uint256 lastUpdated;
        bool isUpgrade;
        uint256 level;
        string imageUri;
        uint256 lastProduct;
    }

    // NFTs minted by this contract
    mapping(uint256 => LumberjackModel) public lumberjackNFTs;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 private mintPrice = INITIAL_PRICE;

    constructor(address tokenAddress) ERC721("Lumberjack", "LUMB") {
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }
}
