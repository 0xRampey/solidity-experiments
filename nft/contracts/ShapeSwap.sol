// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "base64-sol/base64.sol";

contract ShapeSwap is ERC721, ERC721Enumerable, Ownable {
    // TokenIDs mapped to base64 encoded SVGs
    mapping(uint256 => string) public tokenIdToSvg;
    
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    

    constructor() ERC721("ShapeSwap", "Shape") {}

    function safeMint(address to) private onlyOwner {
        _safeMint(to, _tokenIdCounter.current());
        _tokenIdCounter.increment();
    }

    function mintShape(string memory svg) public onlyOwner {
        tokenIdToSvg[_tokenIdCounter.current()] = svg;
      safeMint(msg.sender);
    }

    // function updateColor(hex) {
    //     substitute fill = "" with something else
    // }

    // You could also just upload the raw SVG and have solildity convert it!
    function svgToImageURI(string memory s) public pure returns (string memory) {
        // example:
        // '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
        // would return ""
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(s))));
        return string(abi.encodePacked(baseURL,svgBase64Encoded));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory svg = tokenIdToSvg[tokenId];
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "ShapeSwap", // You can add whatever name here
                                '", "description":"Shape NFTs whose colors can be changed", "attributes":"", "image":"', svgToImageURI(svg),'"}'
                            )
                        )
                    )
                )
            );
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
