# Build with Viction's VVRF

This guide explains how to get random values using a simple contract to request and receive random values from the Viction Verifiable Relatively Random Function (VRRF). The VRRF provides a lightweight, manipulation-resistant random number generator that is ideal for blockchain applications.

## What is VRRF?

VRRF (Verifiable Relatively Random Function) is a pseudo-random number generator designed for blockchain applications, offering verifiable and manipulation-resistant random numbers. Its key features include deterministic outputs for the same inputs (verifiable), the use of previous results combined with on-chain parameters and user-provided salt for unpredictability (relatively random), resistance to manipulation, and quick, on-chain processing within a single transaction. While not perfect in probability distribution, VRRF provides a lightweight solution ideal for applications needing secure and fair random number generation. [Full documentation](https://docs.viction.xyz/developer-guide/smart-contract-development/vrrf).

## Setup your contract for VVRF

```solidity
interface IVRRF {
  /**
   * @notice Get pseudo-random number base on provided seed
   * @param salt Random data as an additional input to harden the random
   */
  function random(bytes32 salt) external view returns(bytes32);
}
```

To integrate the VRRF on Viction into your smart contract, you need to interact with the `IVVRF` interface. This interface provides a random function that returns a 256-bit pseudo-random number based on a provided salt. Below is a step-by-step guide on how to set up your contract to use VRRF. 

| Network  | Address                                      |
|----------|----------------------------------------------|
| Mainnet  | 0x53eDcf19e4fb242c9957CB449d2d4106fD760A7F   |
| Testnet  | 0xDb14c007634F6589Fb542F64199821c3308A9d92   |


## Example Smart Contract: Dice Game
Below is an example of a Dice game smart contract that uses VRRF to roll a dice called `Dice.sol`. 

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

interface IVRRF {
    /**
     * @notice Get pseudo-random number based on provided seed
     * @param salt Random data as an additional input to harden the random
     */
    function random(bytes32 salt) external view returns (bytes32);
}

contract Dice {
    IVRRF public immutable vvrf;

    constructor(address _vvrf) {
        vvrf = IVRRF(_vvrf);
    }

    function roll() public view returns (uint8) {
        bytes32 salt = blockhash(block.number - 1);
        uint256 n = uint256(vvrf.random(salt));
        return uint8((n % 6) + 1);
    }

    function rollWithSalt(bytes32 salt) public view returns (uint8) {
        uint256 n = uint256(vvrf.random(salt));
        return uint8((n % 6) + 1);
    }
}
```

Sure, here's the revised text in Markdown format with corrections:

Here, we can define the **VRRF** and place it in the constructor: `IVRRF public immutable vvrf;`. Once the contract is compiled, depending on the Viction network you are deploying to, you'll need to pass the address. For this guide, we'll be deploying to Viction Testnet (89). Details to add to the testnet can be found [here](https://docs.viction.xyz/developer-guide/deploy-on-viction/viction-testnet). Afterward, we can use the testnet **VRRF** (`0xDb14c007634F6589Fb542F64199821c3308A9d92`) to define it in the Dice contract.

Looking at the functions of `Dice`, Line 22 `roll()` utilise VVRF and Viction's `block.number`. The process utilizes the `blockhash(block.number - 1)` to introduce unpredictability, enhancing randomness the randomness on-chain. While this is deterministic,, the block hash's unpredictability at block creation ensures integrity. Moreover, by incorporating the previous block's hash as a salt, the function further complicates prediction, safeguarding against manipulation and ensuring fairness in random number generation of the dice. To simulates a six-sided dice roll by taking a VVRF result the contract calculates to get a value between 1 and 6. The result is cast to a `uint8` type and returned. Similar the other function `rollWithSalt()` with the purpose to give more control to the roll. 

If you want to use an existing contract, load `0xa72Ee818e7D3d44F0ab86364f38ECd7b4a8f82CC` into an IDE. Then click on roll and the result should be a value between 1 to 6. Note, that the result will change upon after a few seconds. According to the Viction documentation it is good to note that *VRRF relies on the order of calling transaction, protocols who make use of VRRF must wait for a short period of time (say 8-10 seconds) before displaying random result to end-users to avoid issues related to block re-org.*

## Conclusion

VRRF offers a robust solution for generating verifiable and manipulation-resistant random numbers on the blockchain. Its ease of integration and on-chain processing make it an ideal choice for applications requiring fairness and transparency. Whether you are developing games, distributing tasks, or minting NFTs, VRRF provides the reliable randomness you need.