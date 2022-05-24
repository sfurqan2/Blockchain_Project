// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;


import "./AuctionFactory.sol";

contract AuctionParticipation is AuctionFactory{

    event BidPlaced(uint auctionId, address bidder, uint bid);

    modifier onlyOwner(uint _auctionId) {
        require(auctions[_auctionId].owner == msg.sender);
        _;
    }

    function placeBid(uint _auctionId) public payable {
        require(msg.value >= auctions[_auctionId].largestBid + 5);
        require(auctions[_auctionId].start <= block.timestamp && auctions[_auctionId].end >= block.timestamp);

        if(!auctions[_auctionId].open) auctions[_auctionId].open = true;

        auctions[_auctionId].bids[msg.sender] = msg.value;
        
        auctions[_auctionId].secondLargestBid = auctions[_auctionId].largestBid;
        auctions[_auctionId].largestBid = msg.value;
        auctions[_auctionId].highestBidder = msg.sender;

        emit BidPlaced(_auctionId, msg.sender, msg.value);
    }

    function endAuction(uint _auctionId) external onlyOwner(_auctionId){
        payable(msg.sender).transfer(auctions[_auctionId].secondLargestBid + 5);
        payable(auctions[_auctionId].highestBidder).transfer(auctions[_auctionId].largestBid - (auctions[_auctionId].secondLargestBid + 5));
        auctions[_auctionId].open = false;
    }

    function withdraw(uint _auctionId) external{
        require(auctions[_auctionId].bids[msg.sender] > 0);

        payable(msg.sender).transfer(auctions[_auctionId].bids[msg.sender]);
    }

}