// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Proof of Existence contract, version 1
contract ProofOfExistence2 {
  // state
   mapping (bytes32 => bool) public proofs;

  function storeProof(bytes32 proof) public {
    proofs[proof] = true;
  }
  // calculate and store the proof for a document
  // *transactional function*
  function notarize(string memory document) public{
    //checkDocument first here
    if (!checkDocument(document)){
    bytes32 proof = proofFor(document);
    storeProof(proof);
    }
  }
  // helper function to get a document's sha256
  function proofFor(string memory document) public pure returns (bytes32) {
    return sha256(bytes(document));
  }

  // check if a document has been notarized
  // *read-only function*
  function checkDocument(string memory document) public view returns (bool) {
    bytes32 proof = proofFor(document);
    return hasProof(proof);
  }
  // returns true if proof is stored
  // *read-only function*
  function hasProof(bytes32 proof) public view returns (bool) {
    return proofs[proof];
  }
}