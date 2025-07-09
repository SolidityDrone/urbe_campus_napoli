// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../src/CrowdfundingPlatform.sol";

contract Deployer is Script {
    CrowdfundingPlatform public crowdfundingPlatform;
    address public usdc = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
    string public name = "Crowdfunding Platform";
    string public symbol = "CRWD";


    function setUp() public {}
    
    function run() public {
        vm.startBroadcast();

        crowdfundingPlatform = new CrowdfundingPlatform(usdc, name, symbol);

        vm.stopBroadcast();
    } 
}
