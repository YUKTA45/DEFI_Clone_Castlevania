// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

contract KnightsGuild is Ownable(msg.sender) {
    struct Knight {
        string name;
        uint256 xp;
        uint256 level;
    }

    mapping(address => Knight) public knights;
    Knight[] public leaderboard; 

    event LevelUp(address indexed knight, uint256 newLevel);
    event AchievementUnlocked(address indexed knight, uint256 achievementId);

    uint256 public constant XP_PER_LEVEL = 100;

    function registerKnight(string memory _name) public {
        require(bytes(knights[msg.sender].name).length == 0, "Knight already registered");
        knights[msg.sender] = Knight(_name, 0, 1); 
        leaderboard.push(knights[msg.sender]); 
        updateLeaderboard(msg.sender); 
    }

    function addXP(address _knight, uint256 _xpAmount) public { 
        // Allow owner or the contract itself to add XP
        require(msg.sender == owner() || msg.sender == address(this), "Only authorized to add XP"); 

        knights[_knight].xp += _xpAmount; 

        uint256 newLevel = knights[_knight].xp / XP_PER_LEVEL + 1;
        if (newLevel > knights[_knight].level) {
            knights[_knight].level = newLevel;
            emit LevelUp(_knight, newLevel);
            updateLeaderboard(_knight);
        }
    }

    function updateLeaderboard(address _knight) private {
        // (logic to update the leaderboard array based on XP, sorting in descending order)
    }

    function getLeaderboard() public view returns (Knight[] memory) {
        return leaderboard;
    }

    function claimAchievement(uint256 achievementId) public {
        // (logic to validate if the achievement criteria are met)
        emit AchievementUnlocked(msg.sender, achievementId);
    }
}

