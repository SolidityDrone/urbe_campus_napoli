// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ICrowdfundingPlatform} from "./interfaces/ICrowdfundingPlatform.sol";


contract CrowdfundingPlatform is ICrowdfundingPlatform, ERC721{
    
    uint internal counter; 
    uint internal nftCounter; 
    
    IERC20 public usdc;

    mapping(
        uint campaignId => mapping(
            address funder => uint amount)) public s_amountContributed;
    mapping(
        uint campaignId => Campaign) public s_campaigns;


    modifier OnlyCreator(uint campaignId){
        require(s_campaigns[campaignId].creator == msg.sender, "Not creator");
        _;
    }

    constructor(
        address _usdcAddress, 
        string memory _name, 
        string memory _symbol
    ) ERC721(_name, _symbol) {
        usdc = IERC20(_usdcAddress);
    } 

    /////////////////////////////////
    //////CREATORFUNCTIONS//////////
    ////////////////////////////////
    function createCampaign(
        string memory _title, 
        string memory _description, 
        uint _goal, 
        uint64 _expirationDate,
        uint _minimunForNft
    ) public {
        counter++;
        s_campaigns[counter] =  Campaign({
            creator: msg.sender,
            title: _title,
            description: _description,
            goal: _goal,
            expirationDate: _expirationDate,
            amountRaised: 0,
            minimunForNft: _minimunForNft,
            status: CampaignStatus.Active // 0
        });

        emit CampaignCreated(
            counter, 
            msg.sender, 
            _title, 
            _description, 
            _goal, 
            _expirationDate
        );
    }


    function withdraw(uint campaignId) external OnlyCreator(campaignId) {
        Campaign memory campaign = s_campaigns[campaignId];
        if (s_campaigns[campaignId].status == CampaignStatus.Claimed) revert AlreadyClaimed(campaignId);
        if (_isFailed(campaign.expirationDate, campaign.goal, campaign.amountRaised)) revert CampaignFailed(campaignId);

        s_campaigns[campaignId].status = CampaignStatus.Claimed;
        usdc.transfer(msg.sender, campaign.amountRaised);

        emit Withdraw(campaignId, msg.sender, campaign.amountRaised);
    }

    
    /////////////////////////////////
    //////FUNDER_FUNCTIONS//////////
    ////////////////////////////////

    function batchContribute(uint[] memory campaignIds, uint[] memory amounts) external {
        for (uint i; i < campaignIds.length; ++i){
            this.contribute(campaignIds[i], amounts[i]);
        }
    }


    function contribute(
        uint campaignId, 
        uint amountIn
    ) external {
        Campaign memory campaign = s_campaigns[campaignId];
        if (block.timestamp > campaign.expirationDate) 
            revert CampaignExpiredOrDosentExist(campaignId);

        if (campaign.status == CampaignStatus.Completed) revert GoalAchievedAlready(campaignId);

        campaign.amountRaised += amountIn; 
        s_amountContributed[campaignId][msg.sender] += amountIn;

        if (campaign.amountRaised >= campaign.goal){
            campaign.status = CampaignStatus.Completed;
        }
        s_campaigns[campaignId] = campaign;
        usdc.transferFrom(msg.sender, address(this), amountIn);

        if (amountIn >= campaign.minimunForNft) {
            _mint(msg.sender, nftCounter);
        }

        emit Contributed(campaignId, msg.sender, amountIn);
    }
   
    function reclaim(uint campaignId) external {
        Campaign memory campaign = s_campaigns[campaignId];
        uint amountContributed = s_amountContributed[campaignId][msg.sender]; 
        require(amountContributed > 0, "No contribution left");
        if (_isFailed(campaign.expirationDate, campaign.goal, campaign.amountRaised)){
            usdc.transfer(msg.sender, amountContributed);
            delete s_amountContributed[campaignId][msg.sender];
        } else {
            revert CampaignWasSuccesful(campaignId);
        }
    }
    
    function _isFailed(
        uint expiration, 
        uint goal, 
        uint amountRaised
    ) internal view returns (bool){
        return (block.timestamp > expiration && (amountRaised < goal));
    }


    /////////////////////////////////
    //////GETTERS_FUNCTIONS//////////
    ////////////////////////////////

    function getCampaign(uint campaignId) external view returns (Campaign memory){
        return s_campaigns[campaignId];
    }

    function getCampaigns() external view returns (Campaign[] memory){
        Campaign[] memory campaigns = new Campaign[](counter);
        for (uint i; i < counter; ++i){
            campaigns[i] = s_campaigns[i];
        }
        return campaigns;
    }
    
    function getContributions(uint campaignId) external view returns (uint[] memory){
        uint[] memory contributions = new uint[](counter);
        for (uint i; i < counter; ++i){
            contributions[i] = s_amountContributed[campaignId][i];
        }
        return contributions;
    }

    function getCampaignInRange(uint start, uint end) external view returns (Campaign[] memory){
        Campaign[] memory campaigns = new Campaign[](end - start);
        for (uint i; i < end - start; ++i){
            campaigns[i] = s_campaigns[start + i];
        }
        return campaigns;
    }

    function getNftCounter() external view returns (uint){
        return nftCounter;
    }

    function getNft(uint tokenId) external view returns (uint){
        return s_nfts[tokenId];
    }

    function getNftInRange(uint start, uint end) external view returns (uint[] memory){
        uint[] memory nfts = new uint[](end - start);
        for (uint i; i < end - start; ++i){
            nfts[i] = s_nfts[start + i];
        }
        return nfts;
    }

}
