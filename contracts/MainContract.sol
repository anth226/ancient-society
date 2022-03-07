// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/Building.sol";

contract MainContract {
    address private _townhall;
    address private _lumberjack;

    address[] private whitelist;

    function setTownhall(address townhall_) public {
        _townhall = townhall_;
    }

    function setLumberjack(address lumberjack_) public {
        _lumberjack = lumberjack_;
    }

    function setWhitelist(address[] memory newWhitelist) public {
        whitelist = newWhitelist;
    }

    modifier whitelisted(address player) {
        bool isContain = false;

        for (uint256 i = 0; i < whitelist.length; i++) {
            if (whitelist[i] == player) {
                isContain = true;
            }
        }

        require(isContain, "No Whitelist");
        _;
    }

    function allMint(address player)
        public
        payable
        whitelisted(player)
        returns (uint256, uint256)
    {
        uint256 townhallId = IBuilding(_townhall).mint(player);
        uint256 lumberjackId = IBuilding(_lumberjack).mint(player);

        return (townhallId, lumberjackId);
    }
}
