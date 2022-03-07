// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Helper functions OpenZeppelin provides.
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

import "./libraries/Base64.sol";
import "./interface/Building.sol";

// Helper functions OpenZeppelin provides.

contract Townhall is ERC721, Ownable, IBuilding {
    uint256 private constant INITIAL_PRICE = 1;

    string private baseURI;

    uint256 private _mintPrice = INITIAL_PRICE;
    uint256 private _mintPriceDiscount = INITIAL_PRICE;
    address private _fatherContract;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(string memory baseURI_) ERC721 ("Townhall", "ETW") {
        baseURI = baseURI_;
    }

    function tokenURI(uint256 tokenId) public override view returns(string memory) {
        return string(abi.encodePacked(baseURI, "/", tokenId));
    }

    function getPrice() public view returns (uint256) {
        return _mintPrice;
    }

    function setPrice(uint256 price) public {
        _mintPrice = price;
    }

    function setMintPriceDiscount(uint256 price) public {
        _mintPriceDiscount = price;
    }

    function mintPriceDiscount() public view returns(uint256) {
        return _mintPriceDiscount;
    }

    function setFatherContract(address fatherContract_) public {
        _fatherContract = fatherContract_;
    }

    function fatherContract() public view returns(address) {
        return _fatherContract;
    }

    function mint(address player) public override payable returns (uint256) {
        
        uint256 mintPrice;
        
        if(msg.sender == owner()) {
            mintPrice = _mintPrice;
        }

        if(msg.sender == _fatherContract) {
            mintPrice = _mintPriceDiscount * 3;
        }

        if (mintPrice > 0) {
            require(msg.value >= mintPrice, "Not Enough Balance!");
        } else {
            require(false, "Invalid Caller");
        }

        uint256 newItemId = _tokenIds.current();

        _safeMint(player, newItemId);

        _tokenIds.increment();

        return newItemId;
    }
}
