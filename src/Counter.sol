// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICrowfundingPlatform {
    error CampaignDosentExist(uint campaignId);
    error GoalAchievedAlready(uint campaignId);
    error NotCompleted(uint campaignId);
    error AlreadyClaimed(uint campaignId);
    error CampaignFailed(uint campaignId);

    event CampaignCreated(uint indexed campaignId, address indexed creator, string title, string description, uint goal, uint64 expirationDate);
    event Contributed(uint indexed campaignId, address indexed funder, uint amount);
    event Withdraw(uint indexed campaignId, address indexed funder, uint amount);
}

contract CrowdfundingPlatform is ICrowfundingPlatform {
    
    uint counter; // that's 0
    IERC20 public usdc;

    mapping(uint campaignId => mapping(address funder => uint amount)) public s_amountContributed;
    mapping(uint campaignId => Campaign) public s_campaigns;

    enum CampaignStatus {
        Active, // 0
        Completed, // 1
        Failed, // 2
        Claimed
    }

    struct Campaign {
        address creator;
        string title;
        string description;
        uint256 goal;
        uint64 expirationDate;   // block.timestamp
        uint256 amountRaised;
        CampaignStatus status;
    }

    modifier OnlyCreator(uint campaignId){
        _;
        require(s_campaigns[campaignId].creator == msg.sender, "Not creator");
    }


    // usdc 0x036CbD53842c5426634e7929541eC2318f3dCF7e
    constructor(address _usdcAddress){
        usdc = IERC20(_usdcAddress);
    } 

    // user functions
    // 1. create a campaign 
    // 2. contribute to a campaign 
    // 3. withdraw from a campaign 

    function createCampaign(
        string memory _title, 
        string memory _description, 
        uint _goal, 
        uint64 _expirationDate
    ) public {
        counter++;
        s_campaigns[counter] =  Campaign({
            creator: msg.sender,
            title: _title,
            description: _description,
            goal: _goal,
            expirationDate: _expirationDate,
            amountRaised: 0,
            status: CampaignStatus.Active // 0
        });

        emit CampaignCreated(counter, msg.sender, _title, _description, _goal, _expirationDate);
    }

    // important to give approval to the contract
    function contribute(uint campaignId, uint amountIn) external {
        Campaign memory campaign = s_campaigns[campaignId];
        if (block.timestamp > campaign.expirationDate) 
            revert CampaignDosentExist(campaignId);
        if (campaign.status == CampaignStatus.Completed) revert GoalAchievedAlready(campaignId);

        campaign.amountRaised += amountIn; 
        s_amountContributed[campaignId][msg.sender] += amountIn;

        if (campaign.amountRaised >= campaign.goal){
            campaign.status == CampaignStatus.Completed;
        }
        s_campaigns[campaignId] = campaign;
        usdc.transferFrom(msg.sender, address(this), amountIn);

        emit Contributed(campaignId, msg.sender, amountIn);
    }


    
    function withdraw(uint campaignId) external OnlyCreator(campaignId) {
        Campaign memory campaign = s_campaigns[campaignId];
        if (s_campaigns[campaignId].status == CampaignStatus.Claimed) revert AlreadyClaimed(campaignId);
        if (_isFailed(campaign.expirationDate, campaign.goal, campaign.amountRaised)) revert CampaignFailed(campaignId);

        s_campaigns[campaignId].status = CampaignStatus.Claimed;
        usdc.transfer(msg.sender, campaign.amountRaised);

        emit Withdraw(campaignId, msg.sender, campaign.amountRaised);
    }

    function _isFailed(uint expiration, uint goal, uint amountRaised) internal view returns (bool){
        return (block.timestamp > expiration && (amountRaised < goal));
    }


    function batchContribute(uint[] memory campaignIds, uint[] memory amounts) external {
        for (uint i; i < campaignIds.length; ++i){
            contribute(campaignIds[i], amounts[i]);
        }
    }
}
