// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "base64-sol/base64.sol";

// Don't think we need URIStorage module anymore
contract ClockNFT is ERC721URIStorage, Ownable {
	Counters.Counter private _tokenIds;
	// TokenIDs mapped to personal messages
    mapping(uint256 => string) public tokenIdToMessage;
	// TokenIDs mapped to CSS stylesheetss
	mapping(uint256 => string) public tokenIdToCSS;
    // SVG string consisting of
	// 1 -> SVG header
	// 2 -> SVG content
    string[2] public baseSvg;

	constructor() ERC721("ClockNFT", "CLOCK") {
		console.log(block.timestamp);
	}

	function initBaseSvg(string[2] memory s) external onlyOwner {
		baseSvg=s;
	}

	function updateMessage(string calldata s, uint256 tokenId) public {
		require(bytes(s).length < 200, "Message too long!");
		require(ownerOf(tokenId) == msg.sender, "Not auhtorized!" );
		tokenIdToMessage[tokenId] = s;
	}

	// You could also just upload the raw SVG and have solildity convert it!
    function svgToImageURI(string memory s) public pure returns (string memory) {
        // example:
        // '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
        // would return ""
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(s))));
        return string(abi.encodePacked(baseURL,svgBase64Encoded));
    }

	function assembleSvg(uint256 tokenId) public view returns (string memory) {
		return string(abi.encodePacked(
			baseSvg[0], // SVG header
			"<text x=\"0\" y=\"15\" fill=\"red\">",
			tokenIdToMessage[tokenId],
			"</text>",
			baseSvg[1] // Rest of the SVG content
		));
	}

	function mintNFT(string calldata message) external onlyOwner {
		// Make sure base SVG has been set
		require(bytes(baseSvg[0]).length != 0, "Init base SVG!"); 
		uint256 newTokenId = Counters.current(_tokenIds);
		_safeMint(msg.sender, newTokenId);
		// Set the NFT's personal message
		tokenIdToMessage[newTokenId] = message;
		console.log(
			"An NFT w/ ID %s has been minted to %s",
			newTokenId,
			msg.sender
		);
		// Increment the counter for when the next NFT is minted.
		Counters.increment(_tokenIds);
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
        string memory svgNFT = assembleSvg(tokenId);
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                           abi.encodePacked(
                                '{"name":"',
                                "ClockNFT", // You can add whatever name here
                                '", "description":"tick tock tick tock", "attributes":"", "image":"', svgToImageURI(svgNFT),'"}'
                            )
                        )
                    )
                )
            );
    }

}
