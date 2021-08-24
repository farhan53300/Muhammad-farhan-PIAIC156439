// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

Contract ERC20 {
      mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
        address payable owner;
    uint256 private _totalSupply;
    uint price;
        string private _name;
    string private _symbol;
        event Approval(address owner, address spender, uint amount); 
    event Transfer(address sender, address recipient, uint amount);
    event Valuerecieved(address _sender, uint _amount);
    };
       modifier authorization() {
        require (msg.sender == owner, "you are not authorized");
    
    };
        constructor() {
       _name = "ARMY";
       _symbol = "ARMY1";
       _totalSupply = 20000;
        owner = payable (msg.sender);
        _balances[owner] = _totalSupply;
    };
  
    function buytoken(address _seller, address _buyer) public payable returns (uint, uint, string memory) {
   
    price = 1 * 10 ** 18;
   
    require(msg.value % price == 0, "price of 1 token is 1 * 10 ** 16 wei,amount you provided is not exact multiple of unit price");
    require(_buyer != address(0) && _seller != address(0),"not a valid buyer/seller");
    require(msg.value >= price, "insufficient amount" );
    
    uint tokencount = msg.value / price;
    _balances[_buyer] += tokencount;
    _balances[_seller] -= tokencount;
    
    return  (_balances[_seller], _balances[_buyer], "transfer of token from seller to buyer");

    }
    
       
    fallback() external payable{
        emit Valuerecieved(msg.sender, msg.value);
    } 
    function pricesetting(uint _newprice) public  authorization() returns(string memory) {
     price = _newprice;
     return "price adjusted";
    }
        function findingtokenbalance(address _tobechecked) public view authorization() returns(uint) {
        return _balances[_tobechecked];
        
    }
   
   
    function name() public view virtual returns (string memory) {
        return _name;
    }

    
        }

    function transfer(address recipient, uint256 amount) public virtual returns (bool) {
        transfer(msg.sender, recipient, amount);
        return true;
    }

    
    
    function allowance(address _spender) authorization() public view virtual returns (uint256) {
       require(_spender != address(0), "not authentic address");
        return _allowances[owner][_spender];
    }

    
    
    function approve(address spender, uint256 amount) public authorization() virtual returns (bool) {
        _approve(spender, amount);
        return true;
    }

   
    function transferFrom( address _sender, address _recipient, uint256 _amount) public virtual returns (bool) {
       
        transferFrom(_sender, _recipient, _amount);

        uint256 currentAllowance = _allowances[_sender][msg.sender];
        require(currentAllowance >= _amount, "transfer amount exceeds allowance");
        unchecked {
            _approve(msg.sender, currentAllowance - _amount);
        }

        return true;
    }

    
    function increaseAllowance(address _spender, uint256 _addedValue) authorization() public virtual returns (bool) {
        approve(_spender, _allowances[msg.sender][_spender] + _addedValue);
        return true;
    }

    
    function decreaseAllowance(address spender, uint256 subtractedValue) authorization() public virtual returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    
    function transfer(address _sender, address _recipient, uint256 _amount ) internal virtual {
        require(_sender != address(0), "transfer from the zero address");
        require(_recipient != address(0), " transfer to the zero address");

        beforeTokenTransfer(_sender, _recipient, _amount);

        uint256 senderBalance = _balances[_sender];
        require(senderBalance >= _amount, "transfer amount exceeds balance");
        unchecked {
            _balances[_sender] = senderBalance - _amount;
        }
        _balances[_recipient] += _amount;

        emit Transfer(_sender, _recipient, _amount);

        afterTokenTransfer(_sender, _recipient, _amount);
    }

    
    function mint(address account, uint256 amount)  authorization() internal virtual {
        require(account != address(0), " unauthentic minting address");

        beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        afterTokenTransfer(address(0), account, amount);
    }

   
    function burn(address _fromburningaccount, uint256 amount) authorization() internal virtual {
        require(_fromburningaccount != address(0), "unauthorized burning address");

        beforeTokenTransfer(_fromburningaccount, address(0), amount);

        uint256 accountBalance = _balances[_fromburningaccount];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[_fromburningaccount] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(_fromburningaccount, address(0), amount);

        afterTokenTransfer(_fromburningaccount, address(0), amount);
    }
    function _approve(
        
        address spender,
        uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
    function afterTokenTransfer(address from, address to, uint256 amount ) internal virtual {}
    receive() external payable {
        buyToken();
        emit AmountReceived("Receive fallback");
    }
}

contract erccapped is ARMY{

    uint256 public tokenCap; 
    uint256 mintedOn;
    
    constructor(){
         tokenCap = _totalSupply + (500000 *10**_decimals);
    }
    
    modifier transferAfterMonth(){
        uint256 transferOn = 3629543 +  mintedOn ; 
        require(block.timestamp > transferOn && mintedOn > 0,"ERROR: Wait: Transfer date not reached  ");
        _;
    }  
    
    
    address[] tempArrayofAdd;
    mapping(address => uint256) temporaryStay; // it will hold balances for 30 days
    
    
    function mint(address account, uint256 amount)public returns(bool){
        require(_owner == msg.sender, "ERROR: You cant Mint Tokens");
        require(account !=address(0),"ERROR:Mintin to zero Address");
        require(_totalSupply + amount <= tokenCap,"ERROR: Reached the token cap");
    
        
        balances[account] += amount;
    
        _totalSupply += amount;

        emit Transfer(address(0), account, amount);      
        return true;  
    }
    
        function mintForSalaries(address account, uint256 amount)public returns(bool){
        require(_owner == msg.sender, "ERROR: You cant Mint Tokens");
        require(account !=address(0),"ERROR:Mintin to zero Address");
        require(_totalSupply + amount <= tokenCap,"ERROR: Reached the token cap");
        
        mintedOn = block.timestamp;
        
        tempArrayofAdd.push(account);
        temporaryStay[account] += amount;
    
        _totalSupply += amount;

        emit Transfer(address(0), account, amount);      
        return true;  
    }

    function transferSalaries()public transferAfterMonth returns(bool){
        for(uint i=0; i <tempArrayofAdd.length; i++){
        balances[tempArrayofAdd[i]] += temporaryStay[tempArrayofAdd[i]];
        }
        return true;
    }
} 