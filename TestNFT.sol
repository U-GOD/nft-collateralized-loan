// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract TestNFT is ERC721URIStorage {
    uint256 public nextTokenId;

    constructor() ERC721("Test NFT", "TNFT") {}

    function mint(string memory uri) external {
        _safeMint(msg.sender, nextTokenId);
        _setTokenURI(nextTokenId, uri);
        nextTokenId++;
    }
}
