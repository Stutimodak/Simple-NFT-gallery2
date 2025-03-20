// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleNFTGallery {
    struct NFT {
        uint256 id;
        string tokenURI;
        address owner;
    }

    mapping(uint256 => NFT) public nfts;
    mapping(address => uint256[]) private ownerNFTs;
    uint256 public nextTokenId;
    address public owner;

    event NFTMinted(address indexed owner, uint256 tokenId, string tokenURI);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function mintNFT(string memory tokenURI) external onlyOwner {
        nfts[nextTokenId] = NFT(nextTokenId, tokenURI, msg.sender);
        ownerNFTs[msg.sender].push(nextTokenId);

        emit NFTMinted(msg.sender, nextTokenId, tokenURI);
        nextTokenId++;
    }

    function getNFT(uint256 tokenId) external view returns (NFT memory) {
        require(nfts[tokenId].owner != address(0), "NFT does not exist");
        return nfts[tokenId];
    }

    function getAllNFTs() external view returns (NFT[] memory) {
        NFT[] memory allNFTs = new NFT[](nextTokenId);
        for (uint256 i = 0; i < nextTokenId; i++) {
            allNFTs[i] = nfts[i];
        }
        return allNFTs;
    }

    function getMyNFTs() external view returns (NFT[] memory) {
        uint256[] memory tokenIds = ownerNFTs[msg.sender];
        NFT[] memory myNFTs = new NFT[](tokenIds.length);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            myNFTs[i] = nfts[tokenIds[i]];
        }
        return myNFTs;
    }
}

