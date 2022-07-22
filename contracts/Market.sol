// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Market {
	enum ListingStatus {
		Active,
		Sold,
		Cancelled
	}

	struct Listing {
		ListingStatus status;
		address  seller;
		address token;
		uint tokenId;
		uint price;
	}

	event Listed(
		uint listingId,
		address seller,
		address token,
		uint tokenId,
		uint price
	);

	event Sale(
		uint listingId,
		address buyer,
		address token,
		uint tokenId,
		uint price
	);

	event Cancel(
		uint listingId,
		address seller
	);

	uint private _listingId = 0;
	mapping(uint => Listing) private _listings;

	function listToken(address token, uint tokenId, uint price) external {
		IERC721(token).transferFrom(msg.sender, address(this), tokenId);

		Listing memory listing = Listing(
			ListingStatus.Active,
			msg.sender,
			token,
			tokenId,
			price
		);

		_listingId++;

		_listings[_listingId] = listing;

		emit Listed(
			_listingId,
			msg.sender,
			token,
			tokenId,
			price
		);
	}

	function getListing(uint listingId) public view returns (Listing memory) {
		return _listings[listingId];
	}

	function buyToken(uint listingId) public payable {
		Listing storage listing = _listings[listingId];

		require(msg.sender != listing.seller, "Seller cannot be buyer");
		require(listing.status == ListingStatus.Active, "Listing is not active");

		require(msg.value >= listing.price, "Insufficient payment");

		listing.status = ListingStatus.Sold;
		// listing.seller = msg.sender;

		IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);

		payable(listing.seller).transfer(listing.price);


		emit Sale(
			listingId,
			msg.sender,
			listing.token,
			listing.tokenId,
			listing.price
		);
	}

	function cancel(uint listingId) public {
		Listing storage listing = _listings[listingId];

		require(msg.sender == listing.seller, "Only seller can cancel listing");
		require(listing.status == ListingStatus.Active, "Listing is not active");

		listing.status = ListingStatus.Cancelled;
	
		IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);

		emit Cancel(listingId, listing.seller);
	}

    // function resellToken(uint256 listingId, uint256 price) public payable {

	//   Listing storage listing = _listings[listingId];
    //   require(listing.seller == msg.sender, "Only item owner can perform this operation");

	//   listing.status =ListingStatus.Active;
	//   listing.price = price;
	//   listing.seller = msg.sender;

	//   IERC721(listing.token).transferFrom(msg.sender, address(this), listing.tokenId);
    // }
}
