# Unwrapping Wrapped rBTC (WRBTC)

<img src="https://dev.rootstock.io/assets/img/rsk/RBTC-logo.png" style="height:100px; width:100px;">

## What is rBTC?

Before delving into *Wrapped rBTC*, let's grasp what the token **rBTC** is, also known as **Smart Bitcoin**. Essentially it serves as RSK's native token, pegged 1:1 with Bitcoin (BTC). Each RBTC is backed by an equivalent amount of BTC, ensuring stability and trust within the RSK ecosystem. Just like Bitcoin, the total supply of RBTC is capped at **21 million**. To maintain this peg and facilitate secure value transfer between rBTC and BTC, RSK utilizes a mechanism called **Powpeg**. This mechanism allows users to convert their BTC into RBTC by locking their Bitcoin on the BTC network and receiving an equivalent amount of RBTC on Rootstock.

So what makes rBTC important? Just like ETH for the Ethereum, it offers cheaper and faster transactions on the Rootstock network. Whether you're paying for transaction fees or executing smart contracts, RBTC is the currency of choice. Rootstock's ingenious use of **merged mining** allows Bitcoin miners to secure the Rootstock network effortlessly, enhancing security. This setup translates into lower fees and quicker transactions compared to Ethereum, making Rootstock an ideal platform for developers and users alike. Whether you're aiming to build the next revolutionary decentralized app or seeking a more efficient way to transact, RBTC seamlessly bridges the realms of Bitcoin and Ethereum, providing a robust and scalable solution.

| Specification         | Details                           |
| --------------------- | --------------------------------- |
| Token Name            | RBTC                              |
| Total Supply          | 21,000,000 RBTC                   |
| Peg Ratio             | 1:1 with Bitcoin                  |
| Wrapped Token         | Yes                               |
| Peg Mechanism         | PowPeg                            |
| Bridge Smart Contract | Yes                               |
| Maximum Supply        | Aligned with Bitcoin (21 million) |

## What is WRBTC?

**WRBTC**, also known as Wrapped RBTC, is an essential tool for seamless trading of RBTC for other ERC-20 tokens on decentralized platforms across the RSK network. Think of it as a versatile representation of rBTC, ensuring that tokens speak the same language but providing more freedom to work within DeFi and Dapps settings. Wrapping RBTC involves a smart contract exchange for an equivalent token, WRBTC. If you ever want to switch back to native RBTC, a straightforward "unwrapping" process via the same smart contract is all it takes.

But why wrap RBTC in the first place? Here are a few reasons why WRBTC is a game-changer in the DeFi space:
- Swift Transactions - By harnessing RBTC and WRBTC, you can enjoy lightning-fast transaction speeds on the RSK platform, leaving sluggish Bitcoin network transactions in the dust.
- Fostering Interoperability -ER20 tokens adhere to a standard interface, allowing smooth transferability across different blockchain networks. Wrapped tokens bridge these networks, enabling non-native tokens to seamlessly function across various platforms.
- Boosted Liquidity - With each blockchain network typically hosting only one cryptocurrency (like RBTC on RSK and Ether on Ethereum), the demand for DeFi protocols supporting multiple tokens is ever-growing. Wrapped tokens like WRBTC fill this need, enhancing liquidity and capital efficiency for exchanges by expanding trading options and possibilities.

In essence, WRBTC acts as your trusty guide in navigating the interconnected world of decentralized finance, facilitating cross-chain trading and unlocking a wealth of opportunities for savvy traders and investors alike. In the next section, as we take a look at the smart contract, we can understand how WRBTC operates and the simple ERC20 methods that simply `deposit` (wraps) and `withdraw` (unwraps) the RBTC in ERC20 format.

## Unwrapping WRBTC

You can explore the WRBTC smart contract at [0x542FDA317318eBf1d3DeAF76E0B632741a7e677d](https://rootstock.blockscout.com/token/0x542FDA317318eBf1d3DeAF76E0B632741a7e677d) on the mainnet. Taking a look at line 23 in the IDE, we find:

```solidity
string public name     = "Wrapped RBTC";
```

The smart contract contains a receive() function, a special function in Solidity allowing the contract to receive rBTC without requiring a separate function call. When rBTC is sent to the WRBTC contract, this function is automatically triggered, simply calling the deposit() function and storing any amount as WRBTC for the caller, msg.sender. Moving to the deposit() function, it's a public function enabling users to deposit Ether into the contract, payable, meaning it can receive Ether with the function call. Essentially, these methods wrap RBTC to WRBTC.

```solidity
    receive() external payable {
        deposit();
    }
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
```    

The subsequent method on Line 43 is withdraw(), allowing users to withdraw Ether from their account. It verifies if the sender's balance covers the withdrawal amount, reverting the transaction if insufficient. If the balance suffices, it deducts the withdrawn amount and transfers the Ether to the sender's address, unwrapping from WRBTC to RBTC.

```solidity
  function withdraw(uint wad) external {
      require(balanceOf[msg.sender] >= wad);
      balanceOf[msg.sender] -= wad;
      msg.sender.transfer(wad);
      emit Withdrawal(msg.sender, wad);
  }
  ```
  
The remaining methods are methods conforming to the ERC token standard, such as a *transfer functionality* for sending tokens to other addresses and an *approval mechanism* authorizing specific addresses to spend WRBTC tokens on users' behalf. By invoking the approve function, users can designate trusted entities for WRBTC transactions, boosting security and flexibility. WRBTC is a concise yet versatile contract, offering significant utility. Developers can utilize the Solid IDE on the right to access the WRBTC source code provided by the explorer, compile, and interact with the smart contract. Additionally, deploying a version on testnet allows testing of wrapping and unwrapping functionalities.

The WRBTC is a short and simple contract, that provide a lot of utility. Developers can utilize the Solid IDE on the right to access the WRBTC source code provided by the explorer, compile, and interact with the smart contract. Additionally, deploying a version on testnet allows testing of wrapping and unwrapping functionalities using `tRBTC`.