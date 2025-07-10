// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;


interface ICrowdfundingPlatform {

    error CampaignExpiredOrDosentExist(uint campaignId);
    error GoalAchievedAlready(uint campaignId);
    error NotCompleted(uint campaignId);
    error AlreadyClaimed(uint campaignId);
    error CampaignFailed(uint campaignId);
    error CampaignWasSuccesful(uint campaignId);
    error CampaignNotExpired(uint campaignId);
    event CampaignCreated(uint indexed campaignId, address indexed creator, string title, string description, uint goal, uint64 expirationDate);
    event Contributed(uint indexed campaignId, address indexed funder, uint amount);
    event Withdraw(uint indexed campaignId, address indexed funder, uint amount);


    enum CampaignStatus {
        Active,     // 0
        Completed,  // 1
        Claimed     // 2
    }

    struct Campaign {
        address creator;
        string title;
        string description;
        uint256 goal;
        uint64 expirationDate;  
        uint256 amountRaised;
        uint256 minimunForNft;
        CampaignStatus status;
}
}
