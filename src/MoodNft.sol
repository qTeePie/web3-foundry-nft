// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error NFTStateNft__CantFlipNFTStateIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum NFTState {
        SAD,
        HAPPY
    }

    mapping(uint256 => NFTState) private s_tokenIdToNFTState;

    // Constructor takes to parameyters, the sad and happy SVG image URIs (base64 encoded)
    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("NFTState NFT", "MN") {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToNFTState[s_tokenCounter] = NFTState.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI = s_tokenIdToNFTState[tokenId] == NFTState.HAPPY ? s_happySvgImageUri : s_sadSvgImageUri;

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that represents your vibez", "attributes": [{"trait_type": "NFTState", "value": 100}],"image":',
                            '"data:image/svg+xml;base64,',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    // This function will flip the NFTState of the NFT, only approved owners can do this
    function flipNFTState(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert NFTStateNft__CantFlipNFTStateIfNotOwner();
        }
        // Bitwise XOR to flip the NFTState
        s_tokenIdToNFTState[tokenId] = NFTState(uint256(s_tokenIdToNFTState[tokenId]) ^ 1);
    }

    // Since we're orking with base64, we add prefix our tokenURI
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,"; // This is the base URI
    }
}
