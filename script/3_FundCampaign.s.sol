// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../src/CrowdfundingPlatform.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Constants} from "./constants.sol";

contract FundCampaign is Script, Constants {
    CrowdfundingPlatform public crowdfundingPlatform;
    uint public contribution = 2e5;
    uint public campaignId = 1;
    
    function setUp() public {
        crowdfundingPlatform = CrowdfundingPlatform(CROWDFUNDING);
    }
    
    function run() public {
        vm.startBroadcast();
        IERC20(USDC).approve(CROWDFUNDING, 3e6);
        crowdfundingPlatform.contribute(campaignId, contribution);
        
        vm.stopBroadcast();
    } 
}
