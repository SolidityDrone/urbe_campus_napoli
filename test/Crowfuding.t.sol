// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CrowdfundingPlatform} from "../src/Crowdfunding.sol";

contract TestCrowdfunding is Test {
    CrowdfundingPlatform public crowdfundingPlatform;
    address public crowdfundingAddress = 0x31C86930C933E7Ac0f9b84187B7cFE776335F678;
    
    function setUp() public {
        crowdfundingPlatform = CrowdfundingPlatform(crowdfundingAddress);
    }

    function testReadCampaigns() public {
        // First create a campaign to test
        string memory title = "Test Campaign";
        string memory description = "Test Description";
        uint goal = 1000;
        uint64 expirationDate = uint64(block.timestamp + 1 days);
        uint minimumForNft = 100;
        
        crowdfundingPlatform.createCampaign(
            title,
            description,
            goal,
            expirationDate,
            minimumForNft
        );
        
        // Now read the campaign
        (
            address creator,
            string memory campaignTitle,
            string memory campaignDescription,
            uint256 campaignGoal,
            uint64 campaignExpiration,
            uint256 amountRaised,
            uint256 minimunForNft,
            CrowdfundingPlatform.CampaignStatus status
        ) = crowdfundingPlatform.s_campaigns(1);
        
        console.logUint(amountRaised);
    }
}
