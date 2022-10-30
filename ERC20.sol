// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// ERRORS
error ERC20__InsufficientTokens();
error ERC20__OwnerInsufficientTokens();
error ERC20__ExceededAllowanceArray();

contract ERC20 {
    // CONTRACT
    mapping(address => uint256) balanceArray;
    mapping(address => mapping(address => uint256)) public allowanceArray;

    // OPTIONAL
    string tokenName;
    string tokenSymbol;
    uint8 immutable i_decimals;
    // MANDATORY
    uint256 tokenTotalSupply;

    // EVENTS
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        i_decimals = _decimals;
        tokenTotalSupply = _totalSupply;

        // One way to assign initial tokens
        balanceArray[msg.sender] = _totalSupply;
    }

    // OPTIONAL FUNCTIONS
    function name() public view returns (string memory) {
        return tokenName;
    }

    function decimals() public view returns (uint8) {
        return i_decimals;
    }

    // MANDATORY FUNCTIONS
    function totalSupply() public view returns (uint256) {
        return tokenTotalSupply;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balanceArray[owner];
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        if (balanceArray[msg.sender] < value) {
            revert ERC20__InsufficientTokens();
        }

        balanceArray[msg.sender] -= value;
        balanceArray[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    function allowance(address spender, uint256 value)
        public
        returns (bool success)
    {
        allowanceArray[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool success) {
        if (balanceArray[from] < value) {
            revert ERC20__OwnerInsufficientTokens();
        }

        if (allowanceArray[from][msg.sender] < value) {
            revert ERC20__ExceededAllowanceArray();
        }

        balanceArray[from] -= value;
        balanceArray[to] += value;
        allowanceArray[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true;
    }
}
