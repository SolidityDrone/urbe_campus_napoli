// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../src/CrowdfundingPlatform.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Constants} from "./constants.sol";

contract WithdrawCampaign is Script, Constants {  // Also fixed the contract name
    CrowdfundingPlatform public crowdfundingPlatform;
    uint public campaignId = 1;
    
    function setUp() public {
        crowdfundingPlatform = CrowdfundingPlatform(CROWDFUNDING);
    }
    
    function run() public {
        vm.startBroadcast();
        crowdfundingPlatform.withdraw(campaignId);
        vm.stopBroadcast();
    } 
}
