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

    // Constructor takes to parameyters, the sad and happy SVG image URIs (base64 encoded)
    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN") {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI = s_tokenIdToMood[tokenId] == Mood.HAPPY ? s_happySvgImageUri : s_sadSvgImageUri;

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that represents your vibez", "attributes": [{"trait_type": "Mood", "value": 100}],"image":',
                            '"data:image/svg+xml;base64,',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /**
     * Since we're orking with base64, we prefix our tokenURI
     */
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,"; // This is the base URI
    }
}
