# Decentralized Social Media Platform

A blockchain-based social media platform enabling censorship-resistant content sharing, decentralized user management, community moderation, and creator monetization.

## System Architecture

The platform consists of four core smart contracts:

### 1. User Profile Contract (UserProfile.sol)
- Account creation and management
- Profile information storage
- Following/follower relationships
- Reputation scoring
- Identity verification

### 2. Content Contract (ContentManager.sol)
- Content creation and storage
- Content distribution
- IPFS integration
- Metadata management
- Content engagement tracking

### 3. Moderation Contract (CommunityModerator.sol)
- Community governance
- Content flagging system
- Dispute resolution
- Moderator election
- Rule enforcement

### 4. Tipping Contract (CreatorRewards.sol)
- Creator monetization
- Token-based tipping
- Revenue distribution
- Payment streaming
- Reward pool management

## Technical Specifications

### Core Interfaces

#### User Profile Interface
```solidity
interface IUserProfile {
    function createProfile(
        string memory username,
        string memory metadata
    ) external returns (uint256 profileId);

    function updateProfile(
        uint256 profileId,
        string memory metadata
    ) external;

    function follow(
        uint256 targetProfileId
    ) external;
}
```

#### Content Interface
```solidity
interface IContentManager {
    function createPost(
        string memory contentHash,
        string memory metadata,
        uint8 contentType
    ) external returns (uint256 postId);

    function sharePost(
        uint256 postId,
        string memory comment
    ) external;

    function engageContent(
        uint256 postId,
        uint8 engagementType
    ) external;
}
```

### Configuration Parameters
```javascript
const platformConfig = {
    maxUsernameLength: 30,
    minReputationToPost: 0,
    moderationThreshold: 100,        // Votes needed for action
    contentRetentionPeriod: 365,     // Days
    tippingMinimum: "0.0001 ETH",
    moderatorElectionCycle: 30,      // Days
    disputeResolutionPeriod: 7,      // Days
    maxContentSize: 5 * 1024 * 1024  // 5MB
};
```

## Deployment Guide

### Prerequisites
- Solidity ^0.8.0
- Hardhat/Truffle
- IPFS Integration
- OpenZeppelin Contracts

### Installation
```bash
# Install dependencies
npm install @openzeppelin/contracts
npm install ipfs-http-client
npm install hardhat

# Compile contracts
npx hardhat compile

# Deploy platform
npx hardhat run scripts/deploy.js --network [network-name]
```

## Usage Examples

### Creating a Profile
```solidity
function createUserProfile(
    string memory username,
    string memory bio,
    string memory avatarIpfsHash
) external {
    string memory metadata = encodeProfileMetadata(
        bio,
        avatarIpfsHash
    );
    
    uint256 profileId = userProfile.createProfile(
        username,
        metadata
    );
    
    emit ProfileCreated(profileId, username);
}
```

### Creating Content
```solidity
function createPost(
    string memory content,
    string[] memory tags,
    uint8 contentType
) external {
    require(hasMinimumReputation(msg.sender), "Insufficient reputation");
    
    string memory contentHash = uploadToIPFS(content);
    string memory metadata = encodeContentMetadata(tags);
    
    uint256 postId = contentManager.createPost(
        contentHash,
        metadata,
        contentType
    );
}
```

## Event System

### Platform Events
```solidity
event ProfileCreated(
    uint256 indexed profileId,
    string username
);

event ContentPublished(
    uint256 indexed postId,
    address creator,
    uint8 contentType
);

event ModeratorAction(
    uint256 indexed contentId,
    uint8 actionType,
    string reason
);

event CreatorTipped(
    address indexed creator,
    address tipper,
    uint256 amount
);
```

## Content Moderation

### Moderation Flow
1. Community flagging
2. Moderator review
3. Voting period
4. Action execution
5. Appeal process

### Moderator Selection
- Reputation-based eligibility
- Community voting
- Term limits
- Performance tracking

## Monetization Features

### Tipping System
- Direct creator tips
- Content monetization
- Subscription support
- Revenue sharing

### Token Economics
- Platform token utility
- Staking mechanisms
- Reward distribution
- Governance rights

## Security Features

### Access Control
- Role-based permissions
- Content encryption
- Privacy settings
- Account recovery

### Content Protection
- Hash verification
- Timestamp proofs
- Signature validation
- Version control

## Testing Framework

### Test Scenarios
1. Profile management
2. Content creation and sharing
3. Moderation workflows
4. Tipping mechanisms
5. Governance processes

```bash
# Run test suite
npx hardhat test

# Generate coverage report
npx hardhat coverage
```

## Data Storage

### On-chain Storage
- Profile metadata
- Content references
- Engagement metrics
- Reputation scores

### IPFS Integration
- Content storage
- Media handling
- Profile images
- Extended metadata

## Analytics Dashboard

### Platform Metrics
- User engagement
- Content distribution
- Moderation activities
- Economic indicators

## Future Enhancements
- Layer 2 scaling
- Enhanced privacy features
- Advanced content discovery
- Cross-platform integration

## License
MIT License

## Contributing
1. Fork repository
2. Create feature branch
3. Submit pull request
4. Pass code review

## Support
- Documentation portal
- Community forum
- Developer Discord
- Support email
