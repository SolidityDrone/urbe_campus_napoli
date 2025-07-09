// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../src/CrowdfundingPlatform.sol";

contract CreateCampaign is Script {
    CrowdfundingPlatform public crowdfundingPlatform;
    address public usdc = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
    address public crowdfundingAddress = 0x31C86930C933E7Ac0f9b84187B7cFE776335F678;
    uint public goal = 100e6;
    
    uint public minimunForNft = 2e6;

    
    function setUp() public {
        crowdfundingPlatform = CrowdfundingPlatform(crowdfundingAddress);
    }
    
    function run() public {
        vm.startBroadcast();
        crowdfundingPlatform.createCampaign(
            "Test Campaign", 
            "This is a test campaign", 
            goal, 
            uint64(block.timestamp + 30 days), 
            minimunForNft
            );
       

        vm.stopBroadcast();
    } 
}
