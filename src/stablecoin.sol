// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SignedSafeMath.sol";
import "@openzeppelin/contracts/utils/math/UnsignedSafeMath.sol";

contract Stablecoin is ERC20Capped, Ownable, ReentrancyGuard, AccessControl, Pausable {
    using SafeERC20 for IERC20;
    using SignedSafeMath for int256;
    using UnsignedSafeMath for uint256;

    uint256 public exchangeRate;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event ExchangeRateChanged(uint256 newExchangeRate);

    constructor(uint256 initialSupply, uint256 maxSupply) ERC20("USD Stablecoin", "USDs") ERC20Capped(maxSupply) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        exchangeRate = 1;
        _mint(msg.sender, initialSupply);
    }

    function setExchangeRate(uint256 newExchangeRate) external onlyOwner {
        exchangeRate = newExchangeRate;
        emit ExchangeRateChanged(newExchangeRate);
    }

    function deposit() external payable nonReentrant whenNotPaused {
        require(msg.value > 0, "Must send ETH to deposit");
        uint256 tokens = msg.value.div(exchangeRate);
        require(totalSupply().add(tokens) <= cap(), "Exceeds maximum supply");
        _mint(msg.sender, tokens);
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        require(totalSupply().add(amount) <= cap(), "Exceeds maximum supply");
        _mint(to, amount);
    }

    function burn(uint256 amount) external nonReentrant whenNotPaused {
        _burn(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant whenNotPaused {
        uint256 ethAmount = amount.mul(exchangeRate);
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(ethAmount);
    }

    function withdrawAll() external nonReentrant whenNotPaused {
        uint256 amount = balanceOf(msg.sender);
        uint256 ethAmount = amount.mul(exchangeRate);
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(ethAmount);
    }

    function getExchangeRate() external view returns (uint256) {
        return exchangeRate;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Capped, ERC20, Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    receive() external payable {
        deposit();
    }
}