// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract App{
    address public owner;
    bool public paused;
    bool public blockUser;
    uint public treasuryWallet;

    address[] public stakers;

    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor() public{
        owner = msg.sender;
    }

    // Deposit Tokens
    function stakeToken(uint _amount) public {
    
        require(_amount > 0, "amount cannot be 0");
        require(blockUser == false, "User Blocked!");

        stakingBalance[msg.sender] += _amount;
        
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // Withdraw Tokens
    function unstakeToken() public{
        
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, "staking Balance cannot be less than 0");

        stakingBalance[msg.sender] = 0;
        
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        isStaking[msg.sender] = false;

    }

    // Reward function

    function issueRewards() public view returns(uint){
        require(msg.sender == owner, "caller must be the owner");
        
        for (uint i = 0; i < stakers.length; i++){
            address recipient = stakers[i];
            uint reward = stakingBalance[recipient]/100;
            if(reward > 0){
                return reward;
            }
        }
        
    }

    // Pause function
    function setPaused(bool _paused) public {
        require(msg.sender == owner, "You are not the owner");
        paused = _paused;
    }

    function pauseContract() public view{
        require(msg.sender == owner, "Only owner can pause the contract");
        require(paused == false, "Contract Paused");
        
    }

    // Code for treasury wallet
    function depositTax() public{
        uint tax = stakingBalance[msg.sender] * 5 / 100;
        treasuryWallet = stakingBalance[msg.sender] + tax;
    }

    function withdrawTax() public{
        uint tax = stakingBalance[msg.sender] * 5 / 100;
        treasuryWallet = stakingBalance[msg.sender] - tax;
    }

    function treasuryWalletResult() public view returns(uint){
        return treasuryWallet;
    }

    // Block / unblock user
    function setBlockUser(bool _blockUser) public {
        require(msg.sender == owner, "Only owner can block the user");
        blockUser = _blockUser;
    }

 }
