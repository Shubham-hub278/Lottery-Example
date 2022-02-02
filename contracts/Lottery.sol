pragma solidity ^0.8.6;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase  {
    
    enum LotteryState {Closed, Open, WinnerCalculating}

    LotteryState public state;
    address public admin;
    address payable[] public players;
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public lottery_id;
    uint256 public LotteryTime;
    
    uint256 public randomResult;

    mapping (uint256=>address) winners;

    modifier isState(LotteryState _state) {
		require(state == _state, "Wrong state");
		_;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin allowed");
        _;
    }  

    //Hardcoded KOVAN networok address of VRF coordinator and LINK token
    
    constructor() 
        VRFConsumerBase(
            0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9, // VRF Coordinator
            0xa36085F69e2889c224210F603D836748e7dC0088  // LINK Token
        )
    {
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
        admin = msg.sender;
    }

    function startNewLottery() public onlyAdmin{
        require(state==LotteryState.Closed);
        state = LotteryState.Open;
        lottery_id+=1;
        LotteryTime = block.timestamp;
    }
    
    function enter() payable public isState(LotteryState.Open){
        require(msg.sender != admin , "admin not allowed");
        require(state==LotteryState.Open,"Lottery is not open");
        require(block.timestamp<= LotteryTime+3600 seconds,"Lottery Time is finished");
        require(msg.value > 0.01 ether, 'The enter lottery amount must be greater than 0.01 ether');
        players.push(payable(msg.sender));
    }

    function checkState() external onlyAdmin{
        if(block.timestamp>= LotteryTime+3600 seconds){
            state = LotteryState.WinnerCalculating;
            getRandomNumber();
        }
    }
    
    function getLotterWinnigAmount() public view returns(uint) {
        return address(this).balance;
    }
    
    function getplayersList() public view returns(address payable[] memory) {
        return players;
    }
    
      /** 
     * Requests randomness 
     */
    function getRandomNumber() public isState(LotteryState.WinnerCalculating) returns (bytes32 requestId) {
        // require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = (randomness % players.length);
        uint256 index = randomResult;
        payable(players[index]).transfer(address(this).balance); 
        winners[lottery_id]=players[index];
        delete players;
        state = LotteryState.Closed;
    }

    function getstate() public view returns(LotteryState _state){
        return state;
    }
}