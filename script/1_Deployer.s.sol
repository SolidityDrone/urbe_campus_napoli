// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../src/CrowdfundingPlatform.sol";
import {Constants} from "./constants.sol";

contract Deployer is Script, Constants {
    CrowdfundingPlatform public crowdfundingPlatform;
  
    string public name = "Crowdfunding Platform";
    string public symbol = "CRWD";

    function setUp() public {}
    
    function run() public {
        vm.startBroadcast();

        crowdfundingPlatform = new CrowdfundingPlatform(USDC, name, symbol);

        vm.stopBroadcast();
    } 
}
