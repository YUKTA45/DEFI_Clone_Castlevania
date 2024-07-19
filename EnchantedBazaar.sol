// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract EnchantedBazaar {
    IERC20 public token;

    struct Offer {
        address seller;
        uint256 itemId;
        uint256 price;
    }

    Offer[] public offers;

    event ItemListed(uint256 itemId, uint256 price);
    event ItemSold(uint256 itemId, address buyer, address seller, uint256 price);
    event ItemRemoved(uint256 itemId, address seller);

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function listItem(uint256 _itemId, uint256 _price) public {
        offers.push(Offer(msg.sender, _itemId, _price));
        emit ItemListed(_itemId, _price);
    }

    function buyItem(uint256 _offerIndex) public {
        require(_offerIndex < offers.length, "Invalid offer index");

        Offer memory offer = offers[_offerIndex];
        require(offer.price > 0, "Item not for sale");

        // Transfer tokens from buyer to seller
        require(token.transferFrom(msg.sender, offer.seller, offer.price), "Token transfer failed");

        // Emit the ItemSold event
        emit ItemSold(offer.itemId, msg.sender, offer.seller, offer.price);

        // Remove the offer from the marketplace
        removeOffer(_offerIndex);
    }

    function removeOffer(uint256 _offerIndex) public {
        require(_offerIndex < offers.length, "Invalid offer index");
        Offer memory offer = offers[_offerIndex];
        require(offer.seller == msg.sender, "Only the seller can remove the offer");

        // Emit the ItemRemoved event
        emit ItemRemoved(offer.itemId, offer.seller);

        // Remove the offer from the array by replacing it with the last offer and popping the array
        offers[_offerIndex] = offers[offers.length - 1];
        offers.pop();
    }

    function getOffers() public view returns (Offer[] memory) {
        return offers;
    }
}
