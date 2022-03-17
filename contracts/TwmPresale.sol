// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ITwmPresale.sol";

contract TwmPresale is ERC20, ITwmPresale, Pausable, Ownable {
    using SafeMath for uint256;

    uint256 public constant price = 0.05 ether;
    address public nft;
    uint256 public maxSupply = 3333;
    bool public withdrawAllowed = false;

    constructor() ERC20("TWM Presale", "TWM-PRESALE") {
        //
    }

    function deposit() external payable {
        _deposit(_msgSender());
    }

    function withdraw(uint256 amount) external {
        require(withdrawAllowed, "Withdraw not allowed");
        uint256 balance = balanceOf(_msgSender());
        if (amount > balance) amount = balance;
        _burn(_msgSender(), amount);
        _withdraw(_msgSender(), amount.mul(price));
    }

    receive() external payable {
        _deposit(_msgSender());
    }

    // NFT
    function burnFrom(address account, uint256 amount) external override {
        require(_msgSender() == nft, "Not allowed");
        _burn(account, amount);
    }

    // Owner
    function setNft(address nft_) external onlyOwner {
        nft = nft_;
    }

    function setMaxSupply(uint256 maxSupply_) external onlyOwner {
        _checkMaxLimit(maxSupply_, 10000);
        maxSupply = maxSupply_;
    }

    function setWithdrawAllowed(bool withdrawAllowed_) external onlyOwner {
        withdrawAllowed = withdrawAllowed_;
    }

    function setPause(bool status_) external onlyOwner {
        if (status_) _pause();
        else _unpause();
    }

    function depositFunds() external payable onlyOwner {
        //
    }

    function withdrawFunds(uint256 amount) external onlyOwner {
        require(!withdrawAllowed, "Withdraw not allowed");
        _withdraw(owner(), amount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _checkMaxLimit(totalSupply().add(amount), maxSupply);
        _mint(to, amount);
    }

    // Internal
    function _checkMaxLimit(uint256 amount, uint256 max) internal pure {
        require(amount <= max, "Max limit");
    }

    function _deposit(address account) internal whenNotPaused {
        uint256 amount = msg.value.div(price);
        uint256 total = totalSupply();
        if (amount.add(total) > maxSupply) amount = maxSupply.sub(total);
        require(amount > 0, "Must be greater than 0");

        _mint(account, amount);

        uint256 change = msg.value.sub(amount.mul(price));
        if (change > 0) {
            _withdraw(account, change);
        }
    }

    function _withdraw(address recipient, uint256 value) internal {
        (bool success, ) = recipient.call{value: value}("");
        require(success, "Unable to send value, recipient may have reverted");
    }

    // Overrides
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }
}
