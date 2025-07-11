// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../src/CrowdfundingPlatform.sol";
import {Constants} from "./constants.sol";

contract CreateCampaign is Script, Constants {
    CrowdfundingPlatform public crowdfundingPlatform;
    uint public goal = 100e6;
    uint public minimunForNft = 2e6;
    
    function setUp() public {
        crowdfundingPlatform = CrowdfundingPlatform(CROWDFUNDING);
    }
    
    function run() public {
        vm.startBroadcast();
        crowdfundingPlatform.createCampaign(
            "Test Campaign", 
            "This is a test campaign", 
            goal, 
            uint64(block.timestamp + 2 minutes), 
            minimunForNft
            );
        vm.stopBroadcast();
    } 
}
