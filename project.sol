 //SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EduMining {
    address public owner;
    address public eduToken;
    address public lpToken;

    struct Pool {
        uint256 rewardRate;
        uint256 lastUpdateTime;
        uint256 rewardPerTokenStored;
    }

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
    }

    mapping(address => UserInfo) public userInfo;
    mapping(uint256 => Pool) public pools;
    uint256 public poolCount;

    // Events
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _eduToken, address _lpToken) {
        owner = msg.sender;
        eduToken = _eduToken;
        lpToken = _lpToken;
    }

    function stake(uint256 _amount, uint256 _poolId) external {
        require(_amount > 0, "Cannot stake 0");
        require(_poolId < poolCount, "Pool does not exist");

        Pool storage pool = pools[_poolId];
        UserInfo storage user = userInfo[msg.sender];

        updateReward(msg.sender, _poolId);

        user.amount += _amount;
        user.rewardDebt = pool.rewardPerTokenStored;

        // Transfer the LP token from the user to the contract
        // Replace this with actual token transfer logic (ERC20 transfer)
        // lpToken.transferFrom(msg.sender, address(this), _amount);

        emit Staked(msg.sender, _amount);
    }

    function withdraw(uint256 _amount, uint256 _poolId) external {
        require(_amount > 0, "Cannot withdraw 0");
        UserInfo storage user = userInfo[msg.sender];
        require(user.amount >= _amount, "Withdraw amount exceeds balance");

        updateReward(msg.sender, _poolId);

        user.amount -= _amount;

        // Transfer the LP token back to the user
        // Replace this with actual token transfer logic (ERC20 transfer)
        // lpToken.transfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }

    function updateReward(address _user, uint256 _poolId) internal {
        Pool storage pool = pools[_poolId];
        UserInfo storage user = userInfo[_user];

        uint256 timeElapsed = block.timestamp - pool.lastUpdateTime;
        uint256 reward = (timeElapsed * pool.rewardRate * user.amount) / 1e18;

        if (reward > 0) {
            // Reward distribution logic (eduToken transfer)
            // eduToken.transfer(_user, reward);
        }

        pool.lastUpdateTime = block.timestamp;
    }

    // Admin functions
    function createPool(uint256 _rewardRate) external onlyOwner {
        pools[poolCount] = Pool({
            rewardRate: _rewardRate,
            lastUpdateTime: block.timestamp,
            rewardPerTokenStored: 0
        });
        poolCount++;
    }
}
