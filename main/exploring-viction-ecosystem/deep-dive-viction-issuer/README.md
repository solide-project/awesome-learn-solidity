This is a two-part series that will delve into deploying a VRC25 token and leveraging Viction's Issuer for seamless, gasless transactions in VRC25 token operations.
- [Deploying Tokens with VRC25](https://dapp.solide0x.tech/learn/exploring-viction-ecosystem/deploying-gasless-vrc25)
- [Unlocking the VRC25 Gasless Experience (This)](https://dapp.solide0x.tech/learn/exploring-viction-ecosystem/deploying-gasless-vrc25)

## VicIssuer

The `VRC25Issuer` contract facilitates the management of token issuances and transaction fees within the Viction ecosystem, particularly through its `apply` method. This method serves as a pivotal mechanism for token issuers to request issuance capabilities, contingent upon meeting a minimum capital requirement (`_minCap`). Here’s a breakdown of its technical workings and implications:

| Network   | Address                                    |
| --------- | ------------------------------------------ |
| Mainnet   | 0x8c0faeb5c6bed2129b8674f262fd45c4e9468bee |
| Testnet   | 0x8c0faeb5c6bed2129b8674f262fd45c4e9468bee |
### `apply`

An important aspect of creating a gasless token is to *apply* the token to the VicIssuer. This mean, setting up the token address. 

```
    function apply(address token) public payable onlyValidCapacity(token) {
        AbstractTokenTRC21 t = AbstractTokenTRC21(token);
        require(t.issuer() == msg.sender);
        _tokens.push(token);
        tokensState[token] = tokensState[token].add(msg.value);
        emit Apply(msg.sender, token, msg.value);

    }
```

On Line 98 is the implementation of `apply`. Note only that only the token owner (or `issuer`) can apply a token to the Issuer. After that we see that the token get appended to `_tokens` which is a list of all registered token for gasless and updates the issuance state (`tokensState`) with the amount of Ether provided (`msg.value`). This step effectively registers the token issuer within the `VRC25Issuer` contract, enabling subsequent operations related to token management and fee charging.
## Practical Guide,

*This will require a VRC25, take a look the previous guide to deploy a VRC25 token*.

When you load the the `VicIssuer` into the an IDE, you can deploy and interact with it. Let's take a look at the `_minCap`. The value should be `10000000000000000000`. This means that an requirement of 10 VIC will be need to apply for the gasless token.
```
10 $VIC * 18 (decimals) = 10000000000000000000 wei
```

This value will be important as it'll be need to be pass as the `msg.value` when invoking `apply` and thus applying the VRC25 token to the Zero Gas Integration. 
### Apply

![Mint](https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic/main/exploring-viction-ecosystem/deep-dive-viction-issuer/assets/apply.png)

You can enable gasless transactions for your VRC25 token by deploying the token and invoking the `apply` method. This process allows the token to support gasless operations, making transactions smoother and more user-friendly. It's recommended to include a deposit of 10 VIC during this step, which will be used to sponsor the gas fees. This ensures that all transactions remain gasless, enhancing the user experience. If preferred, you can choose to make this deposit at a later stage, but incorporating it during the initial deployment is advisable for seamless integration. To confirm that your VRC25 token has been successfully set up for gasless transactions, you can check the details in the blockchain explorer. This verification step ensures that the token deployment and the application for gasless transactions were executed correctly, providing transparency and assurance that your VRC25 token is ready for seamless, fee-free operations.

![Applied on Vic Issuer](https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic/main/exploring-viction-ecosystem/deep-dive-viction-issuer/assets/applied-issuer.png)
### Found your token address with tokens()

If you take call `tokens()`. It will return the entire list of applied tokens available for the Issuer. The applied token address from before should be there.

![Token List](https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic/main/exploring-viction-ecosystem/deep-dive-viction-issuer/assets/token-list.png)
### Charge (Optionally)

In addition to the VICIssuer's capabilities, there is a crucial method called `charge` that allows you to recharge the token's capacity. This method enables the addition of funds to support ongoing gasless transactions. When you use the `charge` method, you can deposit additional value to the token, ensuring that the token's capacity remains sufficient to cover transaction fees.

```solidity
function charge(address token) public payable {
    tokensState[token] = tokensState[token].add(msg.value);
    emit Charge(msg.sender, token, msg.value);
}
```

By calling this method and sending the required value, you can maintain a continuous, seamless gasless experience for your token holders. This feature ensures that the tokens can always support transaction fees, enhancing the overall user experience and operational efficiency of your VRC25 token.

If you go back to the VRC25 Token and load the VRC25 token. Lets go Address Y from before, or a different address that has some tokens minted. We can test the gasless, by burning some of the token.

Once that been completed, we can take a look at the transaction hash. An gas less burn can used for this resource can be found here: [0xbbd4b30b530093b1e6b1cd169680f389624b0aaf5092cd9b1bd93d106238608d](https://testnet.vicscan.xyz/tx/0xbf8187748ee442c4c2163e6a0e927571145762b19ae96b6d3848cf066f8fb481). From the image transaction in the explorer we can see, the transaction type is **gas sponsored**.

![Gas Sponsor](https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic/main/exploring-viction-ecosystem/deep-dive-viction-issuer/assets/gas-sponsor.png)

If you take a look in the address in the explorer or your wallet. The address will still have there entire amount of VIC.

![After](https://raw.githubusercontent.com/solide-project/awesome-learn-solidity/vic/main/exploring-viction-ecosystem/deep-dive-viction-issuer/assets/after.png)

## Conclusion

The VICIssuer platform simplifies the creation and management of VRC25 tokens, making it accessible to users of all technical backgrounds. By leveraging innovative features like gasless transactions and fee sponsorship, VICIssuer enhances user experience and streamlines blockchain interactions. While this guide provides an overview of the key functionalities, the real magic happens under the hood, offering a transparent way to understand how contracts can use sponsored gas to improve user experience. Explore these features further by visiting the [VICIssuer Testnet](https://issuer-testnet.viction.xyz/).

For a practical example, check out the Gas Zero token used in this guide at the following address: 0xc5632d3194f5337e3b31562b560d3db599769127. You can also verify the successful application of gasless integration on the issuer page.