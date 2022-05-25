// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract AuctionFactory {

    struct Auction{
        uint id;
        uint start;
        uint end;
        address owner;
        address highestBidder;
        uint largestBid;
        uint secondLargestBid;
        bool open;
        mapping(address => uint) bids;
    }

    event AuctionCreated(uint auctionId, address owner, uint start, uint end);

    mapping(uint => Auction) auctions;
    uint numAuctions = 0;

    function createAuction(uint start, uint end) external returns(uint){

        Auction storage auction = auctions[numAuctions++];
        auction.id = numAuctions - 1;
        auction.owner = msg.sender;
        auction.start = block.timestamp + start;
        auction.end = block.timestamp + end;
        auction.highestBidder = address(0);
        auction.largestBid = 0;
        auction.secondLargestBid = 0;

        emit AuctionCreated(auction.id, auction.owner, auction.start, auction.end);

        return numAuctions - 1;
    }

}