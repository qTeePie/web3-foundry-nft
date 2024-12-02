// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MoodNft is ERC721 {
    constructor(string memory sadSvg, string memory happySvg) ERC721("Mood Nft", "MN") {}
}
