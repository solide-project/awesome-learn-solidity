# Rootstock's Universal Smart Contract Interface Registry

## ERC-1820: Pseudo-introspection Registry Contract

This guide is a short documentation and resource to the **ERC-1820: Pseudo-introspection Registry Contract**. The ERC1820 is a crucial component of EVM chains and is often deployed as a contract across any EVM under the address:
```
0x1820a4b7618BdE71dCE8CDC73aAB6c95905FAD24
```

This special smart contract or standard, known as `ERC1820Registry`, revolutionizes how smart contracts and regular accounts communicate. Imagine a world where every address, whether it's a smart contract or a regular user account, can effortlessly register the interfaces it supports and designate the responsible smart contract for their implementation.

At its core, ERC1820 offers a unified registry where entities can declare their functionalities directly or through proxy contracts. This registry serves as a standard of clarity, allowing anyone to query and confirm whether a specific address implements a desired interface and pinpointing the exact smart contract responsible for its execution. 

- You can read the EIP: [EIP-1820](https://eips.ethereum.org/EIPS/eip-1820)
- RSK Equivalent: [RSKIP-148](https://github.com/rsksmart/RSKIPs/blob/e0ac990679a2e6f476e41db0c1050132cd2b1bfc/IPs/RSKIP148.md)
## Rootstock `ERC1820Registry`

The concept of the ERC1820 Registry aligns with the EIP standard. This allows us to utilize and load the address [`0x1820a4b7618BdE71dCE8CDC73aAB6c95905FAD24`](https://rootstock.blockscout.com/address/0x1820a4b7618BdE71dCE8CDC73aAB6c95905FAD24) on the Rootstock mainnet or testnet. By doing so, developers can obtain the implementation of an address in the same way they would on Ethereum.
### `interfaces`

```solidity
mapping(address => mapping(bytes32 => address)) internal interfaces;
```

In the `ERC1820Registry`, this section of the code establishes a crucial mapping mechanism that connects addresses to specific interfaces and their implementers. The outer mapping associates addresses with their respective inner mappings. The inner mappings then use unique interface hashes (represented by bytes32) as keys to link to the addresses of the contracts that implement those interfaces. This setup allows for efficient and convenient retrieval of contract addresses based on the interfaces they support. For example, if a contract wants to interact with another contract that implements a specific interface (identified by its hash), it can easily do so by querying this mapping with the interface hash to obtain the address of the implementing contract.

### `managers`

```solidity
mapping(address => address) internal managers;
```

In the context of ERC1820, another important entity is managers, which are responsible for managing registrations and permissions linked to specific addresses. The manager of an address, whether it's a regular account or a contract, holds the authority to register implementations of interfaces for that address. By default, every address is its own manager. However, the manager can transfer this role to another address by calling `setManager` on the registry contract, providing both the address to transfer the manager role from and the address of the new manager. This mechanism allows for the delegation of management responsibilities and facilitates the efficient governance of interactions within the `ERC1820Registry`.

### `setInterfaceImplementer`

```solidity
function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external {
	address addr = _addr == address(0) ? msg.sender : _addr;
	require(getManager(addr) == msg.sender, "Not the manager");
	require(!isERC165Interface(_interfaceHash), "Must not be an ERC165 hash");
	if (_implementer != address(0) && _implementer != msg.sender) {
		require(
			ERC1820ImplementerInterface(_implementer)
				.canImplementInterfaceForAddress(_interfaceHash, addr) == ERC1820_ACCEPT_MAGIC,
			"Does not implement the interface"
		);
	}
	interfaces[addr][_interfaceHash] = _implementer;
	emit InterfaceImplementerSet(addr, _interfaceHash, _implementer);
}
```

An important implementation in the setter is the `require` statement on `line 97`:

```solidity
require(
	ERC1820ImplementerInterface(_implementer)
		.canImplementInterfaceForAddress(_interfaceHash, addr) == ERC1820_ACCEPT_MAGIC,
	"Does not implement the interface"
);
```

This snippet of code ensures that the ERC1820 registry verifies whether a contract correctly implements a specified interface for a given address. The `require` statement invokes the `canImplementInterfaceForAddress` function on the `_implementer` contract, passing the `_interfaceHash` and `addr` as parameters. If the implementer contract returns the constant `ERC1820_ACCEPT_MAGIC`, it confirms the proper implementation of the interface. Otherwise, the transaction reverts with the error message "Does not implement the interface." This validation is vital in the ERC1820 Registry as it guarantees the integrity and compatibility of contracts claiming to implement specific interfaces, thereby fostering a reliable and interoperable smart contract ecosystem.

```solidity
bytes32 constant internal ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
```

Another significant aspect is determining the interface hash for the `_implementer`. One can derive the hash using `keccak256(string)`. For instance, if the `_implementer` is an ERC777 contract with the interface `ERC777TokensRecipient`, one would pass the keccak256 hash of `ERC777TokensRecipient` as the interface hash.

```typescript 
import { keccak256 } from 'viem' const interfaceHash = keccak256(toHex('ERC777TokensRecipient')
```

An example of querying is `0xa893cdcb731ae8f91cb50f51f28980cdba96b0a6` with the implementation hash of `0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895`. The return value should be `0xa893cdcb731ae8f91cb50f51f28980cdba96b0a6` which is the address of the contract which implements the interface. In this case the contract itself has that interface hash.

While this is a lesser-known standard due to the lack of adoption of ERC-777, we can think of ERC1820 as a decentralized and open source *record book that exists on each blockchain* that anyone can query. Contracts on Rootstock (or any chain with a ERC1820 Registry) can add entries to this mapping, declaring, "I'm `0xabcd...` and I support this interface.". Then anyone, whether a contract or not, can query and get an answer regarding whether the contract supports that interface. This way, if you were to send a token to a contract, you can query that contract via ERC-1820 to see whether it declares support for that token. If it does, you can safely send the tokens.

This is an important concept to learn. Knowing how to utilize the registry can enhance your understanding of contract interactions. Notably, Rootstock supports the ERC1820 Registry, allowing addresses to comprehend the interface of contracts.