# Contracts are deployed in Kovan test network
# contract ExchangeRate
ChainLink     
  /**
  * Network: Kovan
  * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel   
  * Node)
  * Job ID: d5270d1c311941d0b08bead21fea7747
  * Fee: 0.1 LINK
  */

This contract is using ChainLink to fetch change rates for pair EUR / JMD from API: http://api.exchangeratesapi.io/v1/latest?access_key=184ea95cc9f945187254b47d85eed80f&base=EUR&symbols=JMD&format=1

using LINK to fulfill requests

# contract DigitalCurrency contains main logic

# contract JMD is inherited from ExchangeRate and DigitalCurrency deployed in Kovan test network. Created to manipulate with JDR: https://kovan.etherscan.io/address/0x412828551AE0b19526689a47Ab90244f996765C7

# contract EUR is inherited from ExchangeRate and DigitalCurrency deployed in Kovan test network. Created to manipulate with EUR: https://kovan.etherscan.io/address/0x412828551AE0b19526689a47Ab90244f996765C7

![image](https://user-images.githubusercontent.com/44225021/156231550-9f4d8e73-624f-4303-b9bc-06a09515fbe8.png)

changeOwner - changes the owner of smart contract
convertToEUR / convertToJMD - converts tokens from one contract to another using EUR / JMD change rates from ExchangeRate contract
fulfill - used by ChainLink to fulfill the api request
mint - mint new tokens.
requestEURtoJMD - api call by ChainLink
transfer - transfer from to
transferTo - transfer from msg.sender to
withdrawLink - withdraws LINK from contract
balanceOf - fetches balance of specific address
EURtoJMD - exchange rates field
getOwner - returns owner
myBalance - fetches balance of msg.sender
symbol - USD / JMD. Symbol of Digital Currency
totalSupply - total supply
