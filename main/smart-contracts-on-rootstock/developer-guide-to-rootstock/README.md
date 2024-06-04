# Developers Guide to Rootstock

Rootstock, often referred to as **RSK**, is a *Smart Contract* platform that brings the best of both worlds by combining Bitcoin's unparalleled security with Ethereum's versatility in smart contracts. Just imagine harnessing the foundation of Bitcoin while enjoying the *dynamic* and *flexible* capabilities of Ethereum's EVM to build Dapps! 

In this series, we will explore Rootstock and provide a comprehensive yet interactive resource for developers and users to understand the dynamics of Rootstock and what it has to offer, such as smart contracts and the ecosystem's integration with Rootstock. Additionally, we'll delve into the smart contract of **RIF (Rootstock Infrastructure Framework)**, which is a decentralized service for dApps.

## Advantages of Rootstock for Developers

### 1. Enhanced Security and Transparency

The RSK blockchain is a powerful scaling solution for the Bitcoin network, designed to enhance its functionality and security. Transactions on RSK are confirmed and then sent to Bitcoin's base layer for final settlement, ensuring their integrity and immutability. This robust security infrastructure provides both developers and users with peace of mind, knowing their applications and transactions are protected from malicious actors. Rootstock enables Bitcoin users to create and execute smart contracts, extending Bitcoin's use cases and functionality. It achieves this through a **two-way peg system** that allows users to send Bitcoin to the Rootstock chain, converting it to Rootstock's native cryptocurrency, RBTC. This RBTC can then be used within the Rootstock network to interact with smart contracts and dApps.

### 2. Compatibility and Lower Costs

Rootstock, is also a smart contract platform for Bitcoin, employs the **Rootstock Virtual Machine (RVM)**, which utilizes the Ethereum Virtual Machine (EVM). This compatibility means that contracts deployed on EVM can be used on Rootstock with similar, if not identical, *bytecode and opcodes*. Consequently, developers can leverage frameworks, protocols, and smart contract libraries from Solidity-based chains on Bitcoin, gaining the benefits of both ecosystems. Additionally, Rootstock offers the advantage of lower gas costs, making it an efficient and cost-effective alternative for deploying and interacting with smart contracts.

## Bitcoin on Rootstock

rBTC serves as the native token for Rootstock, while tRBTC fulfills the same role on the testnet. As we delve into exploring the smart contracts deployed on Rootstock, users can obtain testnet tokens by visiting https://faucet.rootstock.io/. The mechanism behind rBTC lies in Rootstock's unique peg system, known as the **two-way peg** or **Powpeg**. This system facilitates both *peg-in* and *peg-out* transactions, ensuring maximum security and decentralization for Rootstock through a defense-in-depth approach. By locking BTC on the Bitcoin network and unlocking an equivalent amount of RBTC on the RSK chain, users can seamlessly transition between the two ecosystems. RBTC serves as the primary token for transaction fees on the RSK network, maintaining a 1:1 value ratio with BTC and ensuring a reliable transfer of value across chains.

## PowPeg

As mention **Powpeg** can be called the crucial link between **Bitcoin** and **Rootstock (RSK)**, facilitating smooth transitions of the asset Bitcoin between the two blockchains. Operating on a *two-way peg system*, the Powpeg ensures secure movements of bitcoins to and from the RSK sidechain, eliminating any risk of loss or tampering. At its core, the **Powpeg** relies on a network of tamper-proof devices called **PowHSMs (Hardware Security Modules)**, each safeguarding a private key and running a Rootstock node in **SPV (Simple Payment Verification) mode**. This **SPV mode** ensures that transaction signatures are only generated upon sufficient proof of work, enhancing security. Additionally, Rootstock leverages Bitcoin's mining power through **merged mining**, an important concept to RSK allowing miners to secure both blockchains simultaneously.

Communication between **Powpeg functionaries** occurs transparently over the **Rootstock blockchain**, preventing hidden collusion and ensuring public scrutiny. Furthermore, *firmware attestation* guarantees the legitimacy of **PowHSM firmware**, enhancing overall security. By integrating these layers, the **Powpeg** establishes a robust bridge between Bitcoin and Rootstock, empowering users to leverage the strengths of both networks seamlessly. Whether you're a developer or a crypto enthusiast, the **Powpeg** offers an innovative solution for cross-chain transactions, strengthening the Bitcoin-RSK ecosystem.

If you'd like to delve deeper into PegPow, check out their official documentation [here](https://dev.rootstock.io/rsk/architecture/powpeg/).

## Connecting to Rootstock

| Field              | RSK Mainnet                | RSK Testnet                        |
| ------------------ | -------------------------- | ---------------------------------- |
| Network Name       | RSK Mainnet                | RSK Testnet                        |
| RPC URL            | https://public-node.rsk.co | https://public-node.testnet.rsk.co |
| ChainID            | 30                         | 31                                 |
| Symbol             | RBTC                       | tRBTC                              |
| Block explorer URL | https://explorer.rsk.co    | https://explorer.testnet.rsk.co    |

For development, we have handy tools like Remix and Metamask for seamless contract interaction. Below are the network details you'll need to get started. In our next installment, we'll explore a crucial contract called Wrapped rBTC, essential for converting native rBTC into its Wrapped counterpart, enabling ERC20 swaps and various other functionalities. Meanwhile, check out these valuable developer resources for Rootstock:

- [Rootstock Developer Portal](https://dev.rootstock.io/)
- [Rootstock Explorer](https://explorer.rootstock.io/)