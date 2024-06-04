# Enhancing DeFi with Price Oracles on Rootstock

## Blockchain Oracles

Navigating the world of blockchain can be fascinating yet complex, especially when it comes to understanding how external data interacts with decentralized systems. Enter **blockchain oracles**—bridging the gap between on-chain smart contracts and off-chain real-world data. A popular example is building a weather forecasting app on a blockchain; without an oracle, a smart contract wouldn't know if it's sunny or raining outside without querying the outside world. With Oracles, it can play a role by feeding trustworthy external data (whether tempurature) into the blockchain, ensuring that smart contracts can make informed decisions based on real-world events. Other use case can range from asset prices and sports scores and more. By enabling this interaction, oracles unlock wider of possibilities for decentralized applications (dApps), making them more versatile and impactful.
## BTC/USD Price Feed Oracle

This guide will be going over oracles in Rootstock, moreover Money on Chain's BTC/USD Price Feed. In case you never heard of Money on Chain (MoC), its is a decentralized finance (DeFi) platform built on the Bitcoin blockchain via the Rootstock layer. MoC offers a stablecoin ecosystem designed to minimize volatility and provide stability for users engaging in transactions or investments. 

Looking at the contract address deploy on Rootstock mainnet, 0xA288319ecB63301E21963E21eF3Ca8Fb720D2672, its using Openzeppelin upgradable, meaning implementation are subjected to change to improve the oracle service, however, the interface should remain the same. How the contract oracle works are the price are publish in rounds, via managing and validating price updates, tracking supporter contributions and rewards, setting up with selected providers publishing prices based on consensus and stake.

### Rounds

**CoinPair contracts** operate on a **monthly round-basis**. At the start of each round, the top N price-providers, based on their stake, are selected. These providers are expected to remain active throughout the month. At the end of the round, a new round begins automatically with a fresh selection of providers. Every time a provider publishes a pair-price during the round, they earn **one point**. Simultaneously, reward tokens are accumulated and distributed proportionally to the points earned by each provider at the end of the round.

### Price Publishing

**Price publishing** happens in turns, determined by participants' stakes and the hash of the previous publication block. This hash sets the order for the next publication. 

If a significant price change occurs from the previous publication, it triggers the publishing process. If the designated participant fails to publish within a set number of blocks, the next participant in line steps in. This fallback system ensures continuous price updates.

To publish a price, a **majority consensus** (half plus one) of the selected providers is required. Providers coordinate off-chain, where the willing publisher creates a "publish-message" with details like block number and price. This message is sent to other providers for validation and signature. Once enough signatures are gathered, the message and signatures are submitted to the contract, which verifies the consensus and updates the price accordingly. The code snippet for the verifiying is shown below (`Line 4368`)

```solidity
uint256 validSigs = 0;
address lastAddr = address(0);
for (uint256 i = 0; i < _sigS.length; i++) {
	address rec = _recoverSigner(_sigV[i], _sigR[i], _sigS[i], messageHash);
	address ownerRec = oracleManager.getOracleOwner(rec);
	if (roundInfo.isSelected(ownerRec)) validSigs += 1;
	require(lastAddr < rec, "Signatures are not unique or not ordered by address");
	lastAddr = rec;
}

require(
	validSigs > roundInfo.length() / 2,
	"Valid signatures count must exceed 50% of active oracles"
);
```
## Utilizing the Coin Pair Smart Contract

*Please note that the contract is flattened, making navigation more challenging. You can access the official source code, although it appears to be outdated, [here](https://github.com/money-on-chain/OMoC-Decentralized-Oracle/blob/master/contracts/CoinPairPrice.sol).*

If users wish to confirm whether the price oracle corresponds to the pair they are seeking, they can utilize the `getCoinPair()` function. This function returns a bytes value representing the pair. In Solidity, users can achieve this by compiling and instantiating the contract, then invoking the method. Upon execution, the function should return `0x4254435553440000000000000000000000000000000000000000000000000000`. Subsequently, this value can be converted to a string using `veim` to obtain the pair value, such as BTC/USD, which can be displayed in a frontend or application interface for user clarity and engagement.

```typescript
import { fromHex } from 'viem'

// coinPairBytes should be 0x4254435553440000000000000000000000000000000000000000000000000000
const coinPairBytes = await contract.read.getCoinPair()

const coinPair fromHex(coinPairBytes, 'string')
console.log(coinPair)  // BTCUSD
```

Before delving into how to obtain the BTC/USD price on-chain, let's explore some of the methods and functions in a smart contract that ascertain whether a price remains valid based on the current block number. This functionality is crucial for managing time-sensitive data like the BTC price, ensuring its relevance by verifying if the current block number falls within the valid range since the last publication (`lastPublicationBlock`). If the price data falls within this range (`validPricePeriodInBlocks`), it is considered valid; otherwise, it's deemed invalid.

```solidity
function _isValid() private view returns (bool) {
	require(block.number >= lastPublicationBlock, "Wrong lastPublicationBlock");
	return (block.number - lastPublicationBlock) < validPricePeriodInBlocks;
}
```

But how does the price get updated when it becomes outdated? The `publishPrice()` function within the smart contract, located at `Line 4319`, empowers oracles to report the price of a specific coin pair, ensuring data integrity through rigorous validations. It verifies whether the oracle is part of the active round, validates the message format, price, and block number, and verifies signatures from multiple oracles to secure majority consensus. If all conditions are satisfied, the function publishes the price and logs the event, updating both the `lastPublicationBlock` and `currentPrice` within `_publish()` at `Line 4630`. This robust mechanism ensures reliable, secure, and decentralized price reporting on the blockchain.

Now that we understand how the smart contracts operate, let's delve into what the smart contract accomplishes, highlighting the significance of retrieving the price from the oracle. On `Line 4437`, we encounter the getter method designed to access all pertinent price information, including:
- **`currentPrice`**: Provides the current price in Satoshi, enabling users to track real-time value fluctuations.
- **`isValid()`**: Validates whether the price data is still within the valid period, ensuring data integrity and reliability.
- **`lastPublicationBlock`**: Indicates the block number when the price was last published, offering transparency and historical context.

```solidity
function getPriceInfo()
	external
	view
	override
	returns (
		uint256,
		bool,
		uint256
	)
{
	return (currentPrice, _isValid(), lastPublicationBlock);
}
```

### Checking Price Validity

To check the validity of the price data, you can call the `getIsValid()` function, which returns a boolean value indicating whether the price data is still within the valid period:

```solidity
function getIsValid() external view returns (bool) {
    require(block.number >= lastPublicationBlock, "Wrong lastPublicationBlock");
    return (block.number - lastPublicationBlock) < validPricePeriodInBlocks;
}
```

### Getting the Last Publication Block

To retrieve the block number when the price was last published, you can call the `getLastPublicationBlock()` function:

```solidity
function getLastPublicationBlock() external view returns (uint256) {
    return lastPublicationBlock;
}
```

By calling these functions separately, you can access specific pieces of price-related information stored within the smart contract.

So, the Oracle smart contract for BTC/USD on Rootstock provided by MoC offers a reliable, secure, and decentralized solution for obtaining price data. By leveraging blockchain technology and consensus mechanisms, the oracles ensures the integrity of BTC price information, facilitating various financial activities such as trading, lending, and derivatives on the RSK network. With transparent operations and user-friendly interfaces, the Oracle smart contract empowers users to make informed decisions in the decentralized finance (DeFi) space.