// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Currency.sol";

contract MyContract is Ownable {
    IERC20 public eCedi;
    IERC20 public eNaira;

    event Deposit(uint amount, string currency, address user);
    event Withdrawal(uint amount, string currency, address user);
    event Conversion(
        string from,
        string to,
        uint fromAmount,
        uint toAmount,
        address user
    );

    constructor() Ownable(msg.sender) {
        eCedi = new Currency("eCedi", "UGHS");
        eNaira = new Currency("eNaira", "NGNS");
    }

    function deposit(uint256 amount, string memory currency) public {
        IERC20 token;
        if (keccak256(bytes(currency)) == keccak256(bytes("GHS"))) {
            token = eCedi;
        } else if (keccak256(bytes(currency)) == keccak256(bytes("NGN"))) {
            token = eNaira;
        } else {
            revert("Invalid currency");
        }
        token.transferFrom(address(this), msg.sender, amount);

        emit Deposit(amount, currency, msg.sender);
    }

    function withdraw(uint256 amount, string memory currency) public onlyOwner {
        IERC20 token;
        if (keccak256(bytes(currency)) == keccak256(bytes("GHS"))) {
            token = eCedi;
        } else if (keccak256(bytes(currency)) == keccak256(bytes("NGN"))) {
            token = eNaira;
        } else {
            revert("Invalid currency");
        }
        token.transferFrom(msg.sender, address(this), amount);

        emit Withdrawal(amount, currency, msg.sender);
    }

    function convert(
        uint256 amount,
        string memory from,
        string memory to
    ) public {
        IERC20 tokenFrom;
        IERC20 tokenTo;
        if (keccak256(bytes(from)) == keccak256(bytes("GHS"))) {
            tokenFrom = eCedi;
        } else if (keccak256(bytes(from)) == keccak256(bytes("NGN"))) {
            tokenFrom = eNaira;
        } else {
            revert("Invalid currency");
        }
        if (keccak256(bytes(to)) == keccak256(bytes("GHS"))) {
            tokenTo = eCedi;
        } else if (keccak256(bytes(to)) == keccak256(bytes("NGN"))) {
            tokenTo = eNaira;
        } else {
            revert("Invalid currency");
        }
        tokenFrom.transferFrom(msg.sender, address(this), amount);
        tokenTo.transfer(msg.sender, amount);

        emit Conversion(from, to, amount, amount, msg.sender);
    }
}
