contract LePoint {

    struct Campaign {
        address recipient;
        uint tippingPointWei;
        address[] contributors;
        mapping (address => uint[]) contributions;
        bool tipped;
    }

    bytes32[] public campaignNames;
    mapping (bytes32 => Campaign) public campaigns;

    function createCampaign(bytes32 name, address recipient, uint tippingPoint) {
        if (campaigns[name].recipient != 0) throw;

        campaignNames.push(name);
        
        address[] memory c;
        campaigns[name] = Campaign({
            recipient: recipient,
            tippingPointWei: tippingPoint,
            contributors: c,
            tipped: false
        });
    }
    
    function contributeTo(bytes32 name) {
        Campaign campaign = campaigns[name];
        campaign.contributions[msg.sender].push(msg.value);
        campaign.contributors.push(msg.sender);
        
        if (campaign.tipped)
            campaign.recipient.send(msg.value);
    }

    function checkCampaign(bytes32 name) {
        Campaign campaign = campaigns[name];
        if (campaign.tipped) return;
        
        uint totalContributedWei;
        for (uint i = 0; i < campaign.contributors.length; i++) {
            uint[] contributions = campaign.contributions[campaign.contributors[i]];
            for (uint j = 0; j < contributions.length; j++) {
                totalContributedWei += contributions[j];
            }   
        }
        if (totalContributedWei >= campaign.tippingPointWei) {
            campaign.tipped = true;
            campaign.recipient.send(totalContributedWei);
        }
    }

    function getCampaignNames() constant returns (bytes32[]) {
        return campaignNames;
    }
}
