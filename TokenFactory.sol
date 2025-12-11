// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFactory {
    address public owner;
    event TokenCreated(address indexed tokenAddress, string name, string symbol);

    constructor() {
        owner = msg.sender;
    }

    function createToken(string memory name, string memory symbol, uint256 initialSupply) external returns (address) {
        require(msg.sender == owner, "Only owner can create tokens");
        Token newToken = new Token(name, symbol, initialSupply, msg.sender);
        emit TokenCreated(address(newToken), name, symbol);
        return address(newToken);
    }

    function swapTokens(address tokenFrom, address tokenTo, uint256 amount) external {
        // Simple swap logic - in real dApp, integrate with DEX or liquidity pool
        // For demo: Transfer from sender to this contract, then to recipient (simplified, no real swap)
        IERC20(tokenFrom).transferFrom(msg.sender, address(this), amount);
        IERC20(tokenTo).transfer(msg.sender, amount); // Assume 1:1 for demo; adjust for real rates
    }
}

contract Token is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address recipient
    ) ERC20(name, symbol) Ownable(recipient) {
        _mint(recipient, initialSupply * 10 ** decimals());
    }
}

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}
