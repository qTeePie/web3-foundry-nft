// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood {
        SAD,
        HAPPY
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN") {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory tokenMetadata = string(
            abi.encodePacked(
                '{"name": "',
                name(),
                '", "description": "An NFT that represents your vibez", "attributes": [{"trait_type": "Mood", "value": 100}],"image":',
                '"data:image/svg+xml;base64,',
                Base64.encode(bytes(tokenId % 2 == 0 ? s_happySvgImageUri : s_sadSvgImageUri)),
                '"}'
            )
        );
    }
}
