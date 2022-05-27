// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./UpvoteERC1155.sol";

contract DAOHuntERC721 is ERC721, Ownable {
    uint256 public tokenIdCounter;

    UpvoteERC1155 public upvoteNFT;

    // Mapping from token ID to token URI
    mapping(uint256 => string) private idToUri;
    // user => token Id
    mapping(address => mapping(uint256 => bool)) public hasUpvoted;
    // token Id => users[]
    mapping(uint256 => address[]) public whoUpvoted;

    AggregatorV3Interface priceFeed;
    uint256 feedDecimals;

    uint256 public usdUpvotePriceInWei;
    address public treasury;

    constructor(
        address _upvoteNFT,
        address _priceFeed,
        uint256 _feedDecimals,
        uint256 _usdUpvotePriceInWei,
        address _treasury
    ) ERC721("DAOHunt", "DHNT") {
        upvoteNFT = UpvoteERC1155(_upvoteNFT);
        priceFeed = AggregatorV3Interface(_priceFeed);
        feedDecimals = _feedDecimals;
        usdUpvotePriceInWei = _usdUpvotePriceInWei;
        treasury = _treasury;
    }

    function addDAO(string calldata _uri) external onlyOwner {
        uint256 tokenId = tokenIdCounter;
        idToUri[tokenId] = _uri;
        tokenIdCounter++;
    }

    function upvote(uint256 _id) external payable {
        require(!hasUpvoted[msg.sender][_id], "Already Upvoted");
        uint256 usdSent = getConversionRate(msg.value);
        require(usdSent >= usdUpvotePriceInWei, "Send more Matic");

        upvoteNFT.mint(_id, msg.sender);
        hasUpvoted[msg.sender][_id] = true;
        whoUpvoted[_id].push(msg.sender);
    }

    function withdrawFunds() external {
        require(
            msg.sender == treasury || msg.sender == owner(),
            "Not Authorized"
        );
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return idToUri[tokenId];
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // MATIC/USD rate in 18 decimals
        return uint256(answer * int256(10**(18 - feedDecimals)));
    }

    function getConversionRate(uint256 maticAmount)
        public
        view
        returns (uint256)
    {
        uint256 maticPrice = getPrice();
        uint256 maticAmountInUsd = (maticPrice * maticAmount) / 1 ether;
        // the actual MATIC/USD conversation rate, after adjusting the extra 0s.
        return maticAmountInUsd;
    }
}
