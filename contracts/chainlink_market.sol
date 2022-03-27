// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ChainMarket {

struct Order{
  address owner;
  uint256 tokenAmount;
  bool status;

}

 mapping(uint=> Order) public swaps;

 AggregatorV3Interface internal croPriceFeed;
 AggregatorV3Interface internal  busdPriceFeed;
 IERC20 internal croToken;
 IERC20 internal  busdToken ;

 constructor(address _croAddress, address _busdAddress ) {
        croPriceFeed = AggregatorV3Interface(0x00Cb80Cf097D9aA9A3779ad8EE7cF98437eaE050);
        busdPriceFeed = AggregatorV3Interface(0x833D8Eb16D306ed1FbB5D7A2E019e106B960965A);
        croToken = IERC20(_croToken);
        busdToken = IERC20(_busdToken);
 }

  function getLatestPrice() public view returns (int) {
    (
     uint80 roundID,
      int price,
      uint startedAt,
      uint timeStamp,
      uint80 answeredInRound
    ) = priceFeed.latestRoundData();
    // for ETH / USD price is scaled up by 10 ** 8
    return price / 1e8;
  }
}

interface AggregatorV3Interface {
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int answer,
      uint startedAt,
      uint updatedAt,
      uint80 answeredInRound
    );

    function swap( uint croAmount, uint busdAmount) public {
            require(msg.sender == croPriceFeed || msg.sender == busdPriceFeed, "Not authorized");
            require(croToken .allowance(croPriceFeed, address(this)) >= croAmount, "CRO allowance too low");
            require(busdToken.allowance(croPriceFeed, address(this)) >=busdAmount , "BUSD allowance too low");


              _safeTransferFrom(croToken, croPriceFeed, busdToken, croAmount);
            
            _safeTransferFrom(busdToken, busdPriceFeed, croPriceFeed, busdAmount);
    }

 function _safeTransferFrom(IERC20 token, address sender, address recipient, uint amount) private {bool sent = token.transferFrom(sender, recipient, amount);
            require(sent, "Token transfer failed");

 }

    
}