## VRC725

VRC725 is the official standard for Non-Fungible Tokens (NFTs) in the Viction ecosystem, designed to facilitate a wide range of digital and physical asset management applications. Building on the foundation of the widely recognized ERC721 standard, VRC725 introduces enhanced features such as gas-free operations and extended metadata support. This standard provides a streamlined and efficient approach to creating, tracking, and transferring unique tokens, making it the simplest form of NFTs on Viction. By incorporating mechanisms for gasless transactions and maintaining robust security measures, VRC725 ensures a seamless user experience while supporting diverse use cases from virtual collectibles to tangible property ownership.

## Comparison between VRC725/ERC721 

When examining the relationship between VRC725 and ERC721, it's essential to understand that VRC725 inherits from ERC721. This inheritance means that VRC725 tokens are fundamentally ERC721 tokens, adhering to the [EIP 721 standard](https://eips.ethereum.org/EIPS/eip-721), which ensures compatibility with other Ethereum Virtual Machine (EVM) chains—a significant advantage. However, what truly sets VRC725 apart are the additional features and extensions it incorporates, particularly those defined in the IVRC725 interface.

```solidity
interface ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}
```

What make VRC725 unique to Viction is its extension to ERV721 to allow developers and protocols to take advantage of Viction Zero Gas.

```solidity
interface IVRC725 is IERC721, IERC4494, IERC721Metadata {
    function permitForAll(address owner, address spender, uint256 deadline, bytes memory signature) external;
    function nonceByAddress(address owner) external view returns(uint256);

}
```

## permitForAll

```solidity
function permitForAll(address owner, address spender, uint256 deadline, bytes memory signature) external {
    require(deadline >= block.timestamp, 'VRC725: Permit deadline expired');
    bytes32 digest = _getPermitForAllDigest(spender, _noncesByAddress[owner], deadline);

    (address recoverAddress,, ) = ECDSA.tryRecover(digest, signature);
    require(
        recoverAddress == owner || SignatureChecker.isValidSignatureNow(owner, digest, signature),
        "VRC725: Invalid permit signature"
    );

    _setApprovalForAll(owner, spender, true);

    _noncesByAddress[owner]++;
}
```

The main implementation of IVRC725 `permitForAll` is using `ECDSA.tryRecover` to extract the address from the signature and digest, resulting in the `recoverAddress`. This address should match the owner's address if the signature is valid. This is ensured via the `require` statement, which confirms that the `recoverAddress` or `signature` matches the owner, thereby validating that the permit is genuinely authorized by the owner.

Additionally, the **nonce** is manually incremented here to prevent replay attacks by ensuring each permit request is unique. Since the owner's address is included in the digest, each time the method is called, the nonce increments, making old signatures invalid. This guarantees that each signature can only be used once, enhancing the security of the NFT.

## nonceByAddress

```solidity
function nonceByAddress(address owner) external view returns(uint256) {
    return _noncesByAddress[owner];
}
```

As mention the nonce is useful for tracking the number of permits issued for each token and address. In the case of the VRC725 implementation, this is stored as a `mapping` of an address to a `uint256` number to indicate the number of calls. This enhances the security and integrity of the permit mechanism within the contract.
## Example Smart Contract: VRC725 NFT

Below is an example of an NFT smart contract using VRC725, named `NFTMock.sol`, which can be found on the official [Viction Repository on GitHub](https://github.com/BuildOnViction/vrc725/blob/main/contracts/tests/NFTMock.sol):

```solidity
contract NFTMock is VRC725Enumerable {
    constructor(string memory name, string memory symbol, address issuer) {
        __VRC725_init(name, symbol, issuer);
    }

    function mint(address owner, uint256 tokenId) external onlyOwner {
        _safeMint(owner, tokenId);
    }
}
```

The `NFTMock` contract inherits from `VRC725Enumerable`, leveraging the VRC725 standard with added enumerable capabilities. The contract initialization follows a pattern similar to ERC721, but for VRC725, it uses `__VRC725_init` for proper setup. After deployment, the ABI will include all ERC721 methods, enabling minting, transferring, approving, with the addition permit functionalities.
## Setting up for VRC Gasless

Once the VRC725 token has been deployed, developers can set up their NFT contract on Viction for gasless transactions, similar to VRC25 tokens. An in-depth guide is available [here](https://dapp.solide0x.tech/learn/exploring-viction-ecosystem). Essentially, the contract must be registered with the Viction Issuer contract, and the contract owner needs to deposit 10+ $VIC to support and sponsor gas fees for their users.

## Conclusion

VRC725 is an extension of ERC721 designed to enhance the NFT experience on the Viction blockchain. It improves security with its `permitForAll` function, which facilitates more secure asset transfer and management. These features make VRC725 a robust solution for reliable access control in the evolving blockchain landscape. When deploying your VRC725 contract on Viction, be sure to explore the VIC Issuer resource to enable a gasless experience.