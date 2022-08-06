// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 private seed;

    uint256 public totalWaveCount;
    mapping(address => uint) userToWaveCount;
    mapping(address => string) userToName;
    mapping(address => uint256) lastWaveAt;
    struct Wave {
        string name;
        address waverAddress;
        uint count;
        uint timestamp;
    }

    Wave[] waves;
    address[] allAddresses;
    address[] wonUsers;

    event receivedWave(
        address indexed from,
        string name,
        uint count,
        uint timestamp
    );

    constructor() payable {
        console.log("Helloo!");
        seed = (block.difficulty + block.timestamp) % 100;
    }

    function wave(uint _customCount, string memory _waverName) public {
        require(
            lastWaveAt[msg.sender] + 30 seconds < block.timestamp,
            "30 seconds should be passed after your last try!"
        );
        totalWaveCount += _customCount;
        waves.push(Wave(_waverName, msg.sender, _customCount, block.timestamp));
        lastWaveAt[msg.sender] = block.timestamp;
        allAddresses.push(msg.sender);
        userToWaveCount[msg.sender] += _customCount;
        userToName[msg.sender] = _waverName;
        console.log("%s waved at you!", _waverName);
        emit receivedWave(
            msg.sender,
            _waverName,
            _customCount,
            block.timestamp
        );

        uint ranNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("%s is the random number!", ranNumber);

        if (ranNumber > 50) {
            uint256 giveAwayAmount = 0.0001 ether;

            require(
                giveAwayAmount <= address(this).balance,
                "The contract doesn't have enough money to give this gift to you! :("
            );
            (bool success, ) = (msg.sender).call{value: giveAwayAmount}("");
            require(
                success,
                "Not sure why, but I failed to give you some gift... But no worries, your wave is added to the portal!"
            );
            wonUsers.push(msg.sender);
        }
    }

    function getAllWaves() public view returns (Wave[] memory allWaves) {
        return waves;
    }

    function whoWavesTheMost()
        public
        view
        returns (
            string memory waverName,
            address waverAddress,
            uint waverCount
        )
    {
        address chosenAddress;
        uint biggestWaveCount;
        for (uint index = 0; index < allAddresses.length; index++) {
            uint waveCount = userToWaveCount[allAddresses[index]];
            if (waveCount > biggestWaveCount) {
                biggestWaveCount = waveCount;
                chosenAddress = allAddresses[index];
            }
        }
        return (userToName[chosenAddress], chosenAddress, biggestWaveCount);
    }
}
