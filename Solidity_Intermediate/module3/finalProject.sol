// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

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
    string public constant name = "redtibbyMetacrafterToken";
    string public constant symbol = "rTMT";
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

    // constructor (same as ercToken)
    // also sets owner address as msg.sender during deployment
    constructor(uint total) erc20Token (total) {
        owner = msg.sender;
        whitelisted[msg.sender] = true;
    }

    // event (emitted whenever a token mint occurs)
    event Minted (address indexed minter, address indexed receipient, uint tokens);

    // event (emitted whenever a token burn occurs)
    event Burned (address indexed Burner, uint tokens);

    // event (emitted whenever a whitelist occurs)
    event Chmod (address indexed Owner, address indexed trusted, string indexed permission);

    // event (changes owner)
    event Chown (address indexed oldOwner, address indexed newOwner);


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
        emit Minted(msg.sender, receipient, tokens);
        return true;
    }

    // function (allows whitelisted address to remove tokens from total supply, address must own these tokens)
    function burn (uint tokens) public permitted(msg.sender) enoughBalance(msg.sender, tokens) returns (bool) {
        balances[msg.sender] -= tokens;
        TotalSupply -= tokens;
        emit Burned(msg.sender, tokens);
        return true;
    }

    // function (whitelists a given address)
    function whitelist (address trusted) public onlyOwner returns (bool) {
        whitelisted[trusted] = true;
        emit Chmod(msg.sender, trusted, "whitelisted");
        return true;
    }

    // function (removes address from whitelist)
    function blacklist (address distrusted) public onlyOwner returns (bool) {
        whitelisted[distrusted] = false;
        emit Chmod(msg.sender, distrusted, "blacklisted");
        return true;
    }

    function changeOwner (address newOwner) public onlyOwner returns (bool) {
        address oldOwner = owner;
        owner = newOwner;
        emit Chown(oldOwner, newOwner);
        return true;
    }
}