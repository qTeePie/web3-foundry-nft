// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

pragma solidity ^0.8.18;

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;

    constructor() ERC721("Doggie", "DOG") {
        s_tokenCounter = 0;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {}
}
