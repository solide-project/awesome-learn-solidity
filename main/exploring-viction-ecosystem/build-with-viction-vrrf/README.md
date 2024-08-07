# Build with Viction's VRRF

This guide explains how to get random values using a simple contract to request and receive random values from the Viction Verifiable Relatively Random Function (VRRF). The VRRF provides a lightweight, manipulation-resistant random number generator that is ideal for blockchain applications.

## What is VRRF?

VRRF (Verifiable Relatively Random Function) is a pseudo-random number generator designed for blockchain applications, offering verifiable and manipulation-resistant random numbers. Its key features include deterministic outputs for the same inputs (verifiable), the use of previous results combined with on-chain parameters and user-provided salt for unpredictability (relatively random), resistance to manipulation, and quick, on-chain processing within a single transaction. While not perfect in probability distribution, VRRF provides a lightweight solution ideal for applications needing secure and fair random number generation. [Full documentation](https://docs.viction.xyz/developer-guide/smart-contract-development/vrrf).

## Setup your contract for VRRF

```solidity
interface IVRRF {
  /**
   * @notice Get pseudo-random number base on provided seed
   * @param salt Random data as an additional input to harden the random
   */
  function random(bytes32 salt) external returns(bytes32);
}
```

To integrate the VRRF on Viction into your smart contract, you need to interact with the `IVRRF` interface. This interface provides a random function that returns a 256-bit pseudo-random number based on a provided salt. Below is a step-by-step guide on how to set up your contract to use VRRF. 

| Network  | Address                                      |
|----------|----------------------------------------------|
| Mainnet  | 0x53eDcf19e4fb242c9957CB449d2d4106fD760A7F   |
| Testnet  | 0xDb14c007634F6589Fb542F64199821c3308A9d92   |


## Example Smart Contract: Dice Game
Below is an example of a Dice game smart contract that uses VRRF to roll a dice called `Dice.sol`. 

```solidity
contract Dice {
    IVRRF public immutable vrrf;

    event RollEvent(uint256 timestamp, uint256 n, uint256 value);

    constructor(address _vrrf) {
        vrrf = IVRRF(_vrrf);
    }

    function roll() public returns (uint8) {
        uint256 ts = block.number;
        bytes32 salt = blockhash(ts - 1);
        uint256 n = uint256(vrrf.random(salt));
        uint8 value = uint8((n % 6) + 1);
        emit RollEvent(ts, n, value);
        return value;
    }

    function rollWithSalt(bytes32 salt) public returns (uint8) {
        uint256 n = uint256(vrrf.random(salt));
        uint8 value = uint8((n % 6) + 1);
        emit RollEvent(block.number, n, value);
        return value;
    }
}
```

Here, we can define the **VRRF** and place it in the constructor: `IVRRF public immutable vrrf;`. Once the contract is compiled, depending on the Viction network you are deploying to, you'll need to pass the address. For this guide, we'll be deploying to Viction Testnet (89). Details to add to the testnet can be found [here](https://docs.viction.xyz/developer-guide/deploy-on-viction/viction-testnet). Afterward, we can use the testnet **VRRF** (`0xDb14c007634F6589Fb542F64199821c3308A9d92`) to define it in the Dice contract.

Looking at the functions of `Dice`, Line 27 `roll()` utilise VRRF and Viction's `block.number`. The process utilizes the `blockhash(block.number - 1)` to introduce unpredictability, enhancing randomness the randomness on-chain. While this is deterministic, the block hash's unpredictability at block creation ensures integrity. Moreover, by incorporating the previous block's hash as a salt, the function further complicates prediction, safeguarding against manipulation and ensuring fairness in random number generation of the dice. To simulates a six-sided dice roll by taking a VRRF result the contract calculates to get a value between 1 and 6. The result is cast to a `uint8` type and returned. Similar the other function `rollWithSalt()` with the purpose to give more control to the roll. 

If you want to use an existing contract, load `0x42f8A200d7c7BF4FC6aa435ac0c13E0caF40E06D` into an IDE. Then click on roll and the result should be a value between 1 to 6. Note, that the result will change upon after a few seconds. According to the Viction documentation it is good to note that *VRRF relies on the order of calling transaction, protocols who make use of VRRF must wait for a short period of time (say 8-10 seconds) before displaying random result to end-users to avoid issues related to block re-org.*

### Debugging the `roll()`

To retrieve and debug the roll value, the contract emits a `RollEvent` event that can be decoded to get the desired value. By navigating to the Dice contract on Vicscan and checking the *Event* tab, you can find the emitted event. Regardless of whether the contract is verified or unverified, you can decode the provided data. For example, consider the following data:

```
0x000000000000000000000000000000000000000000000000000000000074a7b9fccbcb761acbe15e37f7956d80da55f601cf9444bc439ddadba7b93b32648a190000000000000000000000000000000000000000000000000000000000000002
```

This data decodes to a roll value of 2. Additionally, you can view the raw value of the VRRF emitted with the key `n`. This value is a `bytes32` type (`114342912035737238189353812130102868447094573821621668253466625880326790220313`), which can be translated to a `uint256` as shown in the Dice Contract.

![Roll Event Log](https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/master/main/exploring-viction-ecosystem/build-with-viction-vrrf/assets/logs.png)

## Conclusion

VRRF (Verifiable Random Function) offers a robust solution for generating verifiable random numbers on the Viction. Its seamless integration and on-chain processing capabilities make it an great for applications such as games, distributing tasks, or minting NFTs, ensuring reliable and unbiased randomness.

By leveraging VRRF, smart contracts can obtain a pseudo-random `bytes32` value, which can be easily converted to a `uint256`. This conversion is perfect for on-chain randomness, providing a cost-effective and secure method within a smart contract. VRRF's reliability and efficiency make it a valuable tool for any blockchain application requiring dependable random number generation.