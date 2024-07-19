// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    constructor() ERC20("Degen", "DGN") {}

    // Minting new tokens, only the owner can mint
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Players can transfer their tokens to others
    function transferTokens(address to, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    // Players can redeem their tokens for items in the in-game store
    function redeemTokens(uint256 itemId) public returns (bool) {
        uint256 cost;
        string memory itemName;

        // Hard-coded items
        if (itemId == 1) {
            cost = 0 * 10 ** 18;
            itemName = "Sword";
        } else if (itemId == 2) {
            cost = 0 * 10 ** 18;
            itemName = "Shield";
        } else if (itemId == 3) {
            cost = 0 * 10 ** 18;
            itemName = "Potion";
        } else {
            revert("Item does not exist");
        }

        require(balanceOf(_msgSender()) >= cost, "Insufficient token balance");

        _burn(_msgSender(), cost);
        // Implement your logic for giving the item to the player here
        // Example: emit an event
        emit ItemRedeemed(_msgSender(), itemId, itemName);

        return true;
    }

    // Players can check their token balance
    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Anyone can burn their own tokens that are no longer needed
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    // Event to log item redemptions
    event ItemRedeemed(
        address indexed user,
        uint256 indexed itemId,
        string itemName
    );
}
