pragma solidity ^0.8.7;

import "./Ownable.sol"

/// @title Ollivanders
/// @dev AgbaD
contract Ollivanders is Ownable {

    event NewWand(uint wandId, string name, uint core);

    uint coolDownTime = 3 hours; // a wand can only attact after 3 hours
    uint coreMod = 10 ** 13; 

    struct Wand {
        uint core;
        string name;
        uint32 readyTime;
        uint32 level;
        uint16 winCount;
        uint16 lossCount;
    }

    Wand[] public wands; // public list of all wands
    mapping (address => uint) ownerToWand; // Owner address to wand id
    mapping (address => uint) ownerWandCount; // Number of wands an address owns

    function generateCore(string memory _wandName) private view returns(uint) {
        uint rand = uint(keccak256(abi.encodePacked(_wandName)));
        return rand % coreMod;
    }

    function createWandInternal(uint _core, string memory _name) internal {
        wands.push(Wand(_core, _name, uint32(block.timestamp + coolDownTime), 1, 0, 0));
        uint id = wands.length - 1;
        ownerToWand[msg.sender] = id;
        ownerWandCount[msg.sender]++;
        emit NewWand(id, _name, _core);
    }

    function createWand(string memory _name) public {
        require(ownerWandCount[msg.sender] == 0);
        uint core = generateCore(_name);
        core = core - core % 100;
        createWandInternal(core, _name);
    }
}
