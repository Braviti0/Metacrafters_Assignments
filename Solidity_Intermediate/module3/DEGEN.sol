// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract erc20Token {

    // State variables
    uint TotalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint256)) private allowances;


    // constructor (mints tokens to msg.sender during contract deployment)
    constructor (uint256 total) {
        TotalSupply = total;
        balances[msg.sender] = total;
    }

    // State constants
    string public constant name = "Degen";
    string public constant symbol = "DGN";
    uint8 public constant decimals = 0;

    // event (emitted for each approval)
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    // event (emitted for each transfer)
    event Transfer(address indexed from, address indexed to, uint tokens);

    // modifier (makes sure an account has sufficient tokens for a given transaction)
    modifier enoughBalance (address spender, uint amount) {
        require(balances[spender] >= amount, "token balance of spender is low");
        _;
    }

    // modifier (makes sure an account has been APPROVED to spend a given number of tokens)
    modifier allowed (address tokenOwner, uint tokens) {
        require(allowance(tokenOwner, msg.sender) >= tokens, "sender is not approved to spend token amount");
        _;
    }

    // view function (returns the total supply of tokens)
    function totalSupply() public view returns (uint256){
        return TotalSupply;
    }

    // view function (returns the token balance for a given address)
    function balanceOf (address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    // view function (returns the token amount approved by A for B to spend)
    function allowance (address tokenOwner, address spender) public view returns (uint) {
        return allowances[tokenOwner][spender];
    }

    // function (transfers tokens from msg.sender to B)
    function transfer (address to, uint tokens) public enoughBalance(msg.sender, tokens) returns (bool) {
        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // function (address A can call this function to allow address B to spend some amount of A's token balance)
    function approve (address spender, uint tokens)  public returns (bool) {
        allowances[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // function (transfers APPROVED tokens from address A to address B)
    function transferFrom (address from, address to, uint tokens) public enoughBalance(from, tokens) allowed(from, tokens) returns (bool) {
        balances[from] -= tokens;
        balances[to] += tokens;
        allowances[from][msg.sender] -= tokens;
        emit Transfer(from, to, tokens);
        return true;
    }

}

// mintable and burnable variant
contract MBerc20 is erc20Token {

    // EXTRA FUNCTIONALITY (NOT ERC20 PREREQUISITE)
    // permit mint and burn of tokens

    // store item struct
    struct item {
        string name;
        uint price;
    }

    mapping (address => uint[]) owned;
    mapping (uint => item) items;
    // constructor (same as ercToken)
    // also sets owner address as msg.sender during deployment
    constructor(uint total) erc20Token (total) {
        items[0] = item("shirt", 20);
        items[1] = item("trouser", 50);
        owner = msg.sender;
        whitelisted[msg.sender] = true;
    }

    // event (emitted whenever a token mint occurs)
    event Minted (address indexed minter, address indexed receipient, uint tokens);

    // event (emitted whenever a token burn occurs)
    event Burned (address indexed Burner, uint tokens);

    // event (changes owner)
    event Chown (address indexed oldOwner, address indexed newOwner);
    
    // event (emitted whenever a token redemption occurs)
    event redeemed (address indexed redeemer,uint indexed item, uint tokens);


    // state variables

    mapping(address => bool) whitelisted;
    address owner; // set by constructor

    // modifier (makes sure given address is whitelisted)
    modifier permitted (address any) {
        require (whitelisted[any],"address is not permitted to mint or burn");
        _;
    }

    // modifier (makes sure given address is the owner address)
    modifier onlyOwner () {
        require (msg.sender == owner, "only Owner address can access this function");
        _;
    }

    // function (allows whitelisted address to mint tokens to any address)
    function mint (address receipient, uint tokens) public permitted(msg.sender) returns (bool) {
        balances[receipient] += tokens;
        TotalSupply += tokens;
        emit Minted(msg.sender, receipient, tokens);
        return true;
    }

    // function (allows any address to remove tokens from total supply, address must own these tokens)
    function burn (uint tokens) public enoughBalance(msg.sender, tokens) returns (bool) {
        balances[msg.sender] -= tokens;
        TotalSupply -= tokens;
        emit Burned(msg.sender, tokens);
        return true;
    }

    function redeem (uint _item) public returns (bool) {
        require(balances[msg.sender] >= items[_item].price, "You don't have enough funds to buy this item");
        uint tokens = items[_item].price;
        balances[msg.sender] -= tokens;
        TotalSupply -= tokens;
        owned[msg.sender].push(_item);
        return true;
    }
    
    function viewOwned (address user) public  view returns (uint[] memory) {
        return owned[user];
    }


    function changeOwner (address newOwner) public onlyOwner returns (bool) {
        address oldOwner = owner;
        owner = newOwner;
        emit Chown(oldOwner, newOwner);
        return true;
    }
} 