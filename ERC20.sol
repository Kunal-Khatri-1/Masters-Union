// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// ERRORS
error ERC20__InsufficientTokens();
error ERC20__OwnerInsufficientTokens();
error ERC20__ExceededAllowance();

contract ERC20 {
    // CONTRACT
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) public allowance;

    // OPTIONAL
    string immutable i_tokenName;
    string immutable i_tokenSymbol;
    uint8 immutable i_decimals;
    // MANDATORY
    uint256 immutable i_tokenSupply;

    // EVENTS
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint8 decimals,
        uint256 totalSupply
    ) {
        i_tokenName = tokenName;
        i_tokenSymbol = tokenSymbol;
        i_decimals = decimals;
        i_tokenSupply = totalSupply;

        // One way to assign initial tokens
        balanceOf[msg.sender] = i_tokenSupply;
    }

    // OPTIONAL FUNCTIONS
    function name() public view returns (string) {
        return i_tokenName;
    }

    function decimals() public view returns (uint8) {
        return i_decimals;
    }

    // MANDATORY FUNCTIONS
    function totalSupply() public view returns (uint8) {
        return i_tokenSupply;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        if (balanceOf[msg.sender] < value) {
            ERC20__InsufficientTokens();
        }

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    function(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool success) {
        if (balanceOf[from] < value) {
            revert ERC20__OwnerInsufficientTokens();
        }

        if (allowance[msg.sender] < value) {
            revert ERC20__ExceededAllowance();
        }

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from] -= value;

        emit Transfer(from, to, value);

        return true;
    }
}
