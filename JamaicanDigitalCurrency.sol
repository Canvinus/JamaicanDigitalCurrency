// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract ExchangeRate is ChainlinkClient {
    using Chainlink for Chainlink.Request;
  
    uint256 public EURtoJMD;
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    /**
     * Network: Kovan
     * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel   
     * Node)
     * Job ID: d5270d1c311941d0b08bead21fea7747
     * Fee: 0.1 LINK
     */
    constructor() {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18;
    }
    
    function requestEURtoJMD() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        request.add("get", "http://api.exchangeratesapi.io/v1/latest?access_key=184ea95cc9f945187254b47d85eed80f&base=EUR&symbols=JMD&format=1");
        
        request.add("path", "rates.JMD");
        
        int timesAmount = 10**10;
        request.addInt("times", timesAmount);
        
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, uint256 _EURtoJMD) public recordChainlinkFulfillment(_requestId)
    {
        EURtoJMD = _EURtoJMD;
    }

    function withdrawLink() external {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());

        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

contract DigitalCurrency{
    //  Using SafeMath library
    using SafeMath for uint256;

    //  symbol of currency
    string public symbol;
    //  Total supply private field
    uint256 _totalSupply;
    //  Owner private field
    address _owner;

    //  Balances
    mapping (address => uint256) balances;

    //  Requires msg.sender to be an owner
    modifier isOwner() {
        require(msg.sender == getOwner(), "Caller is not owner");
        _;
    }

    modifier isSolvent(address _address, uint256 amount) {
        require(amount <= balances[_address], "Insufficent funds");
        _;
    }

    //  When tokens are minted
    event Minted(address who, uint256 amount);

    //  When transfer is succeded
    event Sent(address from, address to, uint amount);

    //  When owner is changed
    event OwnerChanged(address oldOwner, address newOwner);

    //  Sets owner
    function _setOwner(address newOwner) internal{
        _owner = newOwner;
    }

    constructor() {
        _setOwner(msg.sender);
    }
    
    //  Gets owner
    function getOwner() public view returns(address){
        return _owner;
    }

    //  Gets total supply
    function totalSupply() external view returns(uint256){
        return _totalSupply;
    }

    //  Gets the balance of specific address
    //  Only callable by an owner
    function balanceOf(address _address) external isOwner view returns(uint256){
        return balances[_address];
    }

    //  Gets the balance of msg.sender
    function myBalance() external view returns(uint256){
        return balances[msg.sender];
    }

    //  Changes the owner
    //  Only callable by an owner
    function changeOwner(address newOwner) external isOwner{
        emit OwnerChanged(getOwner(), newOwner);

        _setOwner(newOwner);
    }

    //  Mints new tokens
    //  Only callable by an owner
    function mint(uint256 amount) external isOwner {
        _totalSupply += amount;
        balances[msg.sender] = balances[msg.sender].add(amount);

        emit Minted(msg.sender, amount);
    }

    //  Transfers tokens to specific address from msg.sender's address
    function transferTo(address receiver, uint256 amount) external isSolvent(msg.sender, amount){
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[receiver] = balances[receiver].add(amount);

        emit Sent(msg.sender, receiver, amount);
    }

    //  Transfers tokens to specific address from msg.sender's address
    function transfer(address from, address to, uint256 amount) public isSolvent(from, amount){
        balances[from] = balances[from].sub(amount);
        balances[to] = balances[to].add(amount);

        emit Sent(from, to, amount);
    }
}

contract JMD is DigitalCurrency, ExchangeRate{
    constructor() DigitalCurrency() ExchangeRate(){
        symbol = "JMD";
    }

    function convertToEUR(EUR _contract, uint256 amount) external isSolvent(msg.sender, amount){
        uint256 amountToSend = amount / (EURtoJMD / (10**10));
        
        require (amountToSend > 0, "Not enough JMD");
        require(_contract.balanceOf(_contract.getOwner()) >= amountToSend, "Not enough EUR");
        requestEURtoJMD();

        balances[msg.sender] -= amount;
        _contract.transfer(_contract.getOwner(), msg.sender, amountToSend);
    }
}

contract EUR is DigitalCurrency, ExchangeRate{
    constructor() DigitalCurrency() ExchangeRate(){
        symbol = "EUR";
    }

    function convertToJMD(JMD _contract, uint256 amount) external isSolvent(msg.sender, amount){
        uint256 amountToSend = amount * (EURtoJMD / (10**10));

        require (amountToSend > 0, "Not enough EUR");
        require(_contract.balanceOf(_contract.getOwner()) >= amountToSend, "Not enough JMD");
        requestEURtoJMD();

        balances[msg.sender] -= amount;
        _contract.transfer(_contract.getOwner(), msg.sender, amountToSend);
    }
}
