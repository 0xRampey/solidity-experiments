// // SPDX-License-Identifier: MIT
// pragma solidity >=0.4.22 <0.9.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// contract CryptoChads is ERC721, ERC721Enumerable, Ownable {
//     struct ItemToken {
//         string name;
//     }
//     struct ChadToken {
//         ItemToken[2] inventory;
//         bool exists;
//     }

//     using Counters for Counters.Counter;

//     Counters.Counter private _tokenIdCounter;

//     mapping(uint256 => ItemToken) public allItems;
//     mapping(uint256 => ChadToken) public allChads;
    

//     constructor() ERC721("CryptoChads", "CHAD") {}

//     function safeMint(address to) private onlyOwner {
//         _safeMint(to, _tokenIdCounter.current());
//         _tokenIdCounter.increment();
//     }

//     function mintItem(string memory name) public onlyOwner returns (ItemToken memory) {
//         ItemToken memory data;
//         data.name = name;
//         allItems[_tokenIdCounter.current()] = data;
//         safeMint(msg.sender);
//         return data;
//     }

//     function mintChad(string[2] memory items) public onlyOwner {
//         // Mint 2 items
//         ItemToken memory item1 = mintItem(items[0]);
//         ItemToken memory item2 = mintItem(items[1]);
//         // Mint a Chad linking to these 2 items
//         ChadToken memory data;
//         // data.name = _tokenIdCounter.current();
//         data.inventory = [item1, item2];
//         allChads[_tokenIdCounter.current()] = data;
//         safeMint(msg.sender);
//     }

//     function tokenDataOf(uint256 tokenId) public view returns (ItemToken[2] memory) {
//         if (allChads[tokenId].exists) {
//             return allChads[tokenId].inventory;
//         }
//         else {
//             ItemToken memory data;
//             return [allItems[tokenId], data];
//         }
//     }

//     // The following functions are overrides required by Solidity.

//     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
//         internal
//         override(ERC721, ERC721Enumerable)
//     {
//         super._beforeTokenTransfer(from, to, tokenId);
//     }

//     function supportsInterface(bytes4 interfaceId)
//         public
//         view
//         override(ERC721, ERC721Enumerable)
//         returns (bool)
//     {
//         return super.supportsInterface(interfaceId);
//     }
// }
