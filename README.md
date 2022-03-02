#### Contracts are deployed in Kovan test network
#### contract ExchangeRate
ChainLink
  * Network: Kovan
  * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel   
  * Node)
  * Job ID: d5270d1c311941d0b08bead21fea7747
  * Fee: 0.1 LINK

This contract is using ChainLink to fetch change rates for pair EUR / JMD from API: http://api.exchangeratesapi.io/v1/latest?access_key=184ea95cc9f945187254b47d85eed80f&base=EUR&symbols=JMD&format=1

using LINK to fulfill requests

#### contract DigitalCurrency is inherited from ExchangeRate contains main logic

#### contract JMD is inherited from DigitalCurrency deployed in Kovan test network. Created to manipulate with JDR: https://kovan.etherscan.io/address/0x3c2460b42e37D0d9514117598Ea3E6836bC978cC

#### contract EUR is inherited from DigitalCurrency deployed in Kovan test network. Created to manipulate with EUR: https://kovan.etherscan.io/address/0x57aE897c635b85C32f6E32736710c9D4d0beCf6A

![image](https://user-images.githubusercontent.com/44225021/156320484-55328c84-201b-48d0-bf5a-839d358a48e0.png)

* addContract - adds contract to another digital currency
* removeContract - removes contract
* getContracts - gets contracts
* balanceOfOwner - balance of owner
* balanceOf - balance of specific address. Only called by an owner
* myBalance - balance of msg.sender
* changeOwner - changes the owner of smart contract. Only called by an owner
* getOwner - returns owner
* convertToEUR / convertToJMD - converts tokens from one contract to another using EUR / JMD change rates from ExchangeRate contract
* fulfill - used by ChainLink to fulfill the api request
* mint - mint new tokens
* requestEURtoJMD - api call by ChainLink. Called on each convert
* transfer - transfer from to. Only called by another approved contract
* transferTo - transfer from msg.sender to
* withdrawLink - withdraws LINK from contract
* EURtoJMD - exchange rates * 10^10 to keep decimals
* symbol - USD / JMD. Symbol of Digital Currency
* totalSupply - total supply
