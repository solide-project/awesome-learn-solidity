# Understanding RNS Registry

## Introduction to the RIF Naming Service (RNS)

Navigating the world of blockchain can be complex, but the RIF Naming Service (RNS) aims to simplify one crucial aspect: **naming**. Inspired by the familiar Domain Name System (DNS), RNS offers a user-friendly way to manage names and addresses on the Rootstock blockchain. By leveraging a hierarchical tree structure, RNS allows users to effortlessly navigate and control their naming assets, making blockchain interactions more intuitive and accessible. It is similar to Ethereum's ENS but designed with a DNS architecture, providing:

The RIF Naming Service (RNS) is structured around two main components:
- **[RNS Registry](https://dev.rootstock.io/rif/rns/architecture/registry)**: This is a hierarchical registry that organizes domain names in a tree structure. Each domain in the registry is associated with an owner, a resolver, and a Time-To-Live (TTL) value.
- **[Resolver](https://dev.rootstock.io/rif/rns/architecture/MultiCryptoResolver)**: This component is a smart contract that responds to queries by providing the necessary information linked to a domain name, facilitating seamless interaction with the blockchain..

In this documentation, we'll focus on the **Registry**, which can be found at [0xcb868aeabd31e2b66f74e9a55cf064abb31a4ad5](https://rootstock.blockscout.com/address/0xcb868aeabd31e2b66f74e9a55cf064abb31a4ad5). *Note that Solide has set up the contract in a development environment for users to interact with and deploy their own version of RNS.*
## RIF

Before diving into the structure and smart contracts of RNS, it's crucial to understand that **RIF (Rootstock Infrastructure Framework)** is a separate entity and ecosystem that integrates with Rootstock to provide decentralization for RNS. The ecosystem includes the `RIF` token, an *ERC-20 token* used for various services, including purchasing or renting RNS domain names.

One practical application of RNS is *subdomain marketing*. Once a domain name is acquired, the owner can use smart contracts to delegate subdomains to third parties under specific conditions. For instance, the owner of the `token.rsk` domain could delegate the `alice.token.rsk` subdomain to Alice in exchange for **1 RIF Token**.

Smart contracts make this process transparent and efficient, eliminating human error and allowing for a wide range of predefined conditions, such as expiration dates, asset counterparts, or stable pricing. This ensures a seamless and secure management of domain names within the RIF ecosystem.
## RNS Structure

An example of a conversion typically makes it easy to denote a contract or an address with a human-readable name, reducing apparent complexity. The name registry is interpreted as a tree, where the root controls all possible top-level domain names, or **_TLDs_**. The children of TLDs are called **_domains_**, and children of domains are called **_subdomains_**.

(*Note: This is just an example and not factual*)
```
0x542FDA317318eBf1d3DeAF76E0B632741a7e677d => wrbtc.rsk
```

Examples of valid names include:
- `rootstock.rsk`
- `rbtc.rootstock.rsk`
- `wrbtc.token.rsk`

Key aspects of an RNS (and determining its validity) are:
- Top Level Domain **must** be `.rsk`
- The first label is **compulsory**
- Any second and subsequent labels are optional
- All labels must be **alphanumeric and lowercase**
- Labels are delimited by `.`

## Understanding the Registry Contract

Buying an RNS domain name is straightforward with the [RNS Manager](https://beta.manager.rns.rifos.org/). Before diving into the official documentation, it's important to know that RNS names are often converted to their bytes representation for contracts to interpret. This can be done using the `namehash` method, which can be implemented or provided by a framework. For Typescript-based applications, you can use `viem` for this purpose, as detailed [here](https://viem.sh/docs/ens/utilities/namehash.html).

For example, resolving `alice.rsk` can be done as follows:
```typescript
const hash = namehash('alice.rsk');
console.log(hash);
// Output: 0xd8fbeced8cf1a410428fe7bb26d475e4a20f2a03cd15ff508856c26c6ea0ad4d
```
This generates `0xd8fbeced8cf1a410428fe7bb26d475e4a20f2a03cd15ff508856c26c6ea0ad4d`, which is of type `bytes`. If you have compiled and deployed the contract on the Rootstock mainnet, this hash can be passed to the `resolver` view method as the argument for `node` to find the address associated with the domain name.

Although this is not provided in the documentation, it may be useful when using RSK and integrating it into an application at the contract level. All functions and actions detailed in the documentation can be executed via the IDE; simply compile and deploy the RNS Registry contract found below. Note that you may need to purchase an RNS unless you are working with the testnet registry.