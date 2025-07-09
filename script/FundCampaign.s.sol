// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../src/Crowdfunding.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FundCampaign is Script {
    CrowdfundingPlatform public crowdfundingPlatform;
    address public usdc = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
    address public crowdfundingAddress = 0x31C86930C933E7Ac0f9b84187B7cFE776335F678;


    
    function setUp() public {
        crowdfundingPlatform = CrowdfundingPlatform(crowdfundingAddress);
    }
    
    function run() public {
        vm.startBroadcast();
        IERC20(usdc).approve(crowdfundingAddress, 3e6);
        
        crowdfundingPlatform.contribute(1, 3e6);
       

        vm.stopBroadcast();
    } 
}
