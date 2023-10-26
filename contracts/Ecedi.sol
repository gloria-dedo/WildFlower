// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ecedes is ERC20, Ownable {
    uint constant _initial_supply = 1000000 * (10**18);

    constructor() ERC20("Ecedi", "ECD" ) {
        _mint(owner(), _initial_supply);
    }

    function mint(address to, uint256 amount ) public onlyOwner {
        _mint(to, amount);
    }
}