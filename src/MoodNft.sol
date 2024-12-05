// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/Test.sol";

contract MoodNft is ERC721 {
    error NFTStateNft__CantFlipNFTStateIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgUri;
    string private s_happySvgUri;

    enum NFTState {
        SAD,
        HAPPY
    }

    mapping(uint256 => NFTState) private s_tokenIdToState;

    // Constructor takes to parameyters, the sad and happy SVG image URIs (base64 encoded)
    constructor(string memory sadSvgUri, string memory happySvgUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgUri = sadSvgUri;
        s_happySvgUri = happySvgUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToState[s_tokenCounter] = NFTState.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI = s_tokenIdToState[tokenId] == NFTState.HAPPY ? s_happySvgUri : s_sadSvgUri;
        console.log("imageURI: %s", imageURI);

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that represents your vibez", "attributes": [{"trait_type": "moodiness", "value": 100}],"image":',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    // This function will flip the NFTState of the NFT, only approved owners can do this
    function flipMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert NFTStateNft__CantFlipNFTStateIfNotOwner();
        }
        // Bitwise XOR to flip the NFTState
        s_tokenIdToState[tokenId] = NFTState(uint256(s_tokenIdToState[tokenId]) ^ 1);
    }

    // Since we're orking with base64, we add prefix our tokenURI
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,"; // This is the base URI
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySvgUri;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSvgUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
