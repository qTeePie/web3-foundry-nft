// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "src/BasicNFT.sol";
import {DeployBasicNFT} from "script/DeployBasicNFT.s.sol";

contract BasicNFTTest is Test {
    BasicNFT private basicNFT;
    DeployBasicNFT private deployer;

    address private USER = makeAddr("user");
    string private constant URI_CAT_BLACK = "ipfs://QmavGzuwMBbCN6dhkmQycjgUMeZELLAK7i7cUn91Cc4HKm";

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expected = "Kitty";
        string memory actual = basicNFT.name();

        assert(keccak256(abi.encodePacked(expected)) == keccak256(abi.encodePacked(actual)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNFT.mintNFT(URI_CAT_BLACK);

        assert(basicNFT.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(basicNFT.tokenURI(0))) == keccak256(abi.encodePacked(URI_CAT_BLACK)));
    }
}
