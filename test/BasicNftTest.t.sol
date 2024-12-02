// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft private basicNft;
    DeployBasicNft private deployer;

    address private USER = makeAddr("user");
    string private constant URI_CAT_BLACK = "ipfs://QmavGzuwMBbCN6dhkmQycjgUMeZELLAK7i7cUn91Cc4HKm";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expected = "Kitty";
        string memory actual = basicNft.name();

        assert(keccak256(abi.encodePacked(expected)) == keccak256(abi.encodePacked(actual)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(URI_CAT_BLACK);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(URI_CAT_BLACK)));
    }
}
