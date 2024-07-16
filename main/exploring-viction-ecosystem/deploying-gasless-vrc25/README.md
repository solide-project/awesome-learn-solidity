This is a two-part series that will delve into deploying a VRC25 token and leveraging Viction's Issuer for seamless, gasless transactions in VRC25 token operations.
- [Deploying Tokens with VRC25 (This)](https://dapp.solide0x.tech/learn/exploring-viction-ecosystem/deploying-gasless-vrc25)
- [Unlocking the VRC25 Gasless Experience](https://dapp.solide0x.tech/learn/exploring-viction-ecosystem/deploying-gasless-vrc25)

## VRC25

The VRC25 standard introduces a game-changing feature: gasless transactions. This means users no longer need native tokens for transaction fees; instead, they can use VRC25 tokens, simplifying the process and making it more user-friendly, especially for newcomers to the blockchain. A key highlight is that VRC25 allows smart contracts to sponsor transaction fees, enhancing their functionality and demonstrating Viction's focus on user-centric solutions. While retaining the familiar ERC20 structure for compatibility, VRC25 improves the user experience by streamlining token transfers and fee management, making blockchain more accessible and https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic for everyone.

## Comparison between VRC25/ERC20 

*For the official overview of the VRC25 specification, take a look at Viction's VRC25 Documentation: [VRC25 Specification](https://docs.viction.xyz/developer-guide/standards-and-specification/vrc25-specification).*

Let's take a look at the specification by examining the `contracts/interfaces/IVRC25.sol` file:

```solidity
interface IVRC25 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Fee(address indexed from, address indexed to, address indexed issuer, uint256 value);

    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function issuer() external view returns (address);
    function allowance(address owner, address spender) external view returns (uint256);
    function estimateFee(uint256 value) external view returns (uint256);
    function transfer(address recipient, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}
```

When comparing this to a simplified `ERC20.sol` interface, you'll notice that the methods are largely similar:

```solidity
interface IERC20 { 
    function totalSupply() external view returns (uint256); 
    function balanceOf(address account) external view returns (uint256); 
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256); 
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool); 
}
```

The `IVRC25` interface presents a structure that's instantly recognizable to anyone familiar with ERC20. It includes functions like `totalSupply`, `balanceOf`, `transfer`, `allowance`, `approve`, and `transferFrom`, preserving the core capabilities that guarantee compatibility and simplicity of integration. These functions enable fundamental token operations such as checking balances, transferring tokens, and managing allowances, ensuring that all essential functionalities for token management are well-supported.
### `issuer`

The `issuer` function verifies the address of the token issuer, ensuring only the designated issuer can manage transaction fees. This adds a layer of security and accountability, maintaining the token's integrity.

```solidity
function issuer() external view returns (address);
```

### `estimateFee`

The `estimateFee` function calculates the transaction fee in VRC25 tokens, which is payable to the token issuer. This function allows for customized fee structures, enhancing flexibility for issuers.

```solidity
function estimateFee(uint256 value) external view returns (uint256);
```

By leveraging `estimateFee`, user wallets can inform users about transaction costs, improving financial planning and transparency. This integration makes VRC25 more user-friendly, allowing better management of transaction fees within the blockchain ecosystem.

## Setting up VRC25 with EIP-2612 (VRC25Permit)

The integration of VRC25Permit with Viction's VRC25 token offers a seamless gasless experience for users and applications, accessible in the IDE under `contracts/interfaces/IVRC25Permit.sol`. Traditionally, ERC-20 token transfers to contracts require a two-step process: approval and transfer, each needing blockchain transactions and gas fees. VRC25Permit simplifies this by combining approval and transfer into a single step through an off-chain signature, reducing transactions, lowering gas fees, and enhancing user convenience.

### Features of VRC25Permit

Examining the interface reveals two key methods crucial for enabling gasless token transactions:

- **Nonces:** The `nonces` function returns the current nonce for the token owner. Each successful call to `permit` increments this nonce, ensuring that every signature is unique and cannot be reused.

  ```solidity
  function nonces(address owner) external view returns (uint256);
  ```

- **Permit Function:** This function allows the token owner to authorize a spender to transfer tokens on their behalf. It verifies that the spender is a valid address, the deadline is a future timestamp, and the signature is valid using the current nonce of the owner. The `permit` function is the core feature of VRC25Permit, enabling token owners to sign off-chain approval messages. These messages specify the amount, recipient, and duration of the permission, providing security and transparency.

  ```solidity
  function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
  ```

## Example Smart Contract: SampleVRC25

*Entire source code can be found from the official Viction Repository: https://github.com/BuildOnViction/vrc25/blob/main/contracts/tests/SampleVRC25.sol*

We can load the entire Solide IDE implementation with the `VRC25` and `VRC25Permit` implementation. If you want to take a look and understand the implementation you can view the implementation but this resource should provide sufficient information to understand the VRC25 token under the hood. 

Looking at `SampleVRC25.sol`, it implements the `VRC25Permit`, which implements `VRC25`, so the Sample Token will include all the token and permit methods for the token. For starters, we can edit Line 10 constructor parameters to a more appropriate token name and symbol

```
constructor() public VRC25("Example Fungible Token", "EFT", 0)
```

The `SampleVRC25` contract extends the functionality of the VRC25 token standard by integrating the `VRC25Permit` extension. This extension enables gasless transactions through off-chain signatures, enhancing user convenience and reducing transaction costs.

## Setting up for VRC Gasless

Once a the VRC25 token has been deployed, let's create and use another address, *Address Y*, and fund it with using [Viction Testnet Faucet](https://faucet-testnet.viction.xyz/).

With this funding, we can mint the sample VRC25 token to *Address Y*. While this initial interaction will incur gas fees, the minted tokens will enable Address Y to participate in token burning. In the next steps, we will apply Viction's Issuer functionality to allow Address Y to burn tokens without incurring gas fees (as well as minting), making the process https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic and cost-effective.

![Mint](https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic/main/exploring-viction-ecosystem/deploying-gasless-vrc25/assets/mint.png)

## Conclusion

The VRC25 standard introduces advanced token management features while conforming to the familiar ERC20 structure, ensuring compatibility and ease of integration. With unique methods like `issuer` and `estimateFee`, VRC25 enhances security, transparency, and user control, making it a robust solution for token operations on the Viction blockchain. The following guide will focus on another smart contract known as the `VicIssuer` which delves into the integration for enabling gasless operations.
