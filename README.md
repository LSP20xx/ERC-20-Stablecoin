#Stablecoin Contract

This is a Solidity contract for a stablecoin, which is a type of cryptocurrency that is pegged to a stable asset, usually a fiat currency such as USD. The stablecoin in this contract is called "USD Stablecoin" and has the ticker symbol "USDs".

##Overview

This contract extends the OpenZeppelin ERC20Capped, Ownable, ReentrancyGuard, AccessControl, and Pausable contracts. It includes the following features:

The stablecoin has a capped maximum supply, which is set during contract deployment.
The stablecoin can be minted by users with the "MINTER_ROLE" permission.
The exchange rate between Ether and the stablecoin can be set by the contract owner.
Users can deposit Ether into the contract to receive stablecoins at the current exchange rate.
Users can burn stablecoins to withdraw Ether at the current exchange rate.
The contract can be paused by the owner in case of emergency.

##Usage

To use this contract, you will need a development environment for Solidity, such as Remix or Truffle. You will also need to have the OpenZeppelin contracts installed as dependencies.

Clone this repository and navigate to the directory in your terminal.
Install the OpenZeppelin dependencies by running npm install.
Open the Stablecoin.sol file in your Solidity development environment.
Set the initial supply and maximum supply of the stablecoin in the constructor.
Deploy the contract to your chosen network (e.g. localhost, Ropsten, etc.).
Mint some stablecoins by calling the mint function with the MINTER_ROLE permission.
Set the exchange rate by calling the setExchangeRate function as the contract owner.
Users can deposit Ether into the contract by calling the deposit function and passing along the Ether value in wei.
Users can burn stablecoins to withdraw Ether by calling the burn function and passing along the amount of stablecoins to burn.
The contract owner can pause and unpause the contract as needed by calling the pause and unpause functions, respectively.

##License

This contract is licensed under the MIT License. See the LICENSE file for more information.
