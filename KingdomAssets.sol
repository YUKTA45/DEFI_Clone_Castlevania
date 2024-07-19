// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KingdomAssets is ERC721, Ownable(msg.sender) {
    uint256 private _currentTokenId = 0;

    mapping(uint256 => string) private _tokenURIs; // For storing metadata URIs

    event AssetMinted(address indexed to, uint256 tokenId, string uri);
    event AssetTransferred(address indexed from, address indexed to, uint256 tokenId);

    constructor() ERC721("KingdomAssets", "KAS") {}

    function mint(address to, string memory uri) external onlyOwner returns (uint256) {
        require(bytes(uri).length > 0, "URI must not be empty");

        _currentTokenId++;
        uint256 newTokenId = _currentTokenId;

        _mint(to, newTokenId);
        _setTokenURI(newTokenId, uri);

        emit AssetMinted(to, newTokenId, uri);

        return newTokenId;
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        _tokenURIs[tokenId] = uri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function transferAsset(address from, address to, uint256 tokenId) external onlyOwner {
        require(ownerOf(tokenId) == from, "Incorrect owner");
        require(to != address(0), "Cannot transfer to the zero address");

        safeTransferFrom(from, to, tokenId);

        emit AssetTransferred(from, to, tokenId);
    }

    function getCurrentTokenId() external view returns (uint256) {
        return _currentTokenId;
    }
}
