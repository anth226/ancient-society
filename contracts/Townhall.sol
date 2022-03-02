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

contract Townhall is ERC721URIStorage, Ownable, Building {
    uint256 private constant INITIAL_PRICE = 1;
    uint256 private constant ININTAL_UPGRADE_DELAY = 1 minutes;
    uint256 private constant INITIAL_RESOURCE_DELAY = 1 minutes;

    struct TownhallModel {
        uint256 lastUpdated;
        bool isUpgrade;
        uint256 level;
        string imageUri;
        uint256 lastProduct;
    }

    // NFTs minted by this contract
    mapping(uint256 => TownhallModel) public townhallNFTs;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 private mintPrice = INITIAL_PRICE;
    address private immutable ancienTokenAddress;

    constructor(address tokenAddress) ERC721("Townhall", "ETW") {
        ancienTokenAddress = tokenAddress;
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    function getPrice() public view returns (uint256) {
        return mintPrice;
    }

    function setPrice(uint256 price) public {
        mintPrice = price;
    }

    function mint(address player, string memory imageUri)
        public
        payable
        returns (uint256)
    {
        require(msg.value >= mintPrice, "Not Enough Balance!");
        uint256 newItemId = _tokenIds.current();

        TownhallModel memory newTownhall = TownhallModel({
            lastUpdated: block.timestamp,
            level: 1,
            imageUri: imageUri,
            isUpgrade: false,
            lastProduct: block.timestamp
        });

        _safeMint(player, newItemId);

        townhallNFTs[newItemId] = newTownhall;

        _tokenIds.increment();
        return newItemId;
    }

    /**
     * Format NFT data for display
     */
    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        TownhallModel memory townhall = townhallNFTs[_tokenId];

        string memory nftId = Strings.toString(_tokenId);
        string memory level = Strings.toString(townhall.level);

        // "{",
        //     '"name": " Townhall -- NFT #: ', nftId, '",',
        //     '"description": "The Town Hall will be the core NFT in the game, earning players $ANCIEN. In accordance with fair world economics, it will be the hardest Building to upgrade but the most rewarding of them all",',
        //     '"image": "', townhall.imageUri, '",',
        //     '"attributes": [', 
        //         '{ "trait_type": "Level", "value": "', level,'" }',
        //     "]",
        // "}"

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        "{",
                            '"name": " Townhall -- NFT #: ', nftId, '",',
                            '"description": "The Town Hall will be the core NFT in the game, earning players $ANCIEN. In accordance with fair world economics, it will be the hardest Building to upgrade but the most rewarding of them all",',
                            '"image": "', townhall.imageUri, '",',
                            '"attributes": [', 
                                '{ "trait_type": "Level", "value": "', level,'" }',
                            "]",
                        "}"
                    )
                )
            )
        );
        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }

    function isUpgrade(uint256 _tokenId) public view returns (bool) {
        TownhallModel memory townhall = townhallNFTs[_tokenId];

        return townhall.lastUpdated + ININTAL_UPGRADE_DELAY < block.timestamp;
    }

    function upgrade(uint256 _tokenId) public {
        TownhallModel memory townhall = townhallNFTs[_tokenId];

        require(isUpgrade(_tokenId) == true, "Upgrading Now!");

        townhall.level += 1;
        townhall.lastUpdated = block.timestamp;

        townhallNFTs[_tokenId] = townhall;
    }

    function getUpgradeTime(uint256 _tokenId) public view returns (uint256) {
        TownhallModel memory townhall = townhallNFTs[_tokenId];
        return townhall.lastUpdated;
    }

    function claimRewards(uint256 amount) public {
        require(amount <= 0, "Claim: wrong amount");
        IERC20(ancienTokenAddress).transfer(msg.sender, amount);
    }
}
