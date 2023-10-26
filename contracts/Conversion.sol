// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ecedi.sol";
contract Conversion is Ownable { 
    // The token converted from
    ERC20 public tokenFrom;

    // The token converted to
   Ecedes public tokenTo;

    // Address where cash is collected
    address payable public wallet;

    constructor( address payable _wallet, ERC20 _tokenTo, ERC20 _tokenFrom) {
        require(_wallet != address(0));

        // SETUP WALLET AND TOKENS
        wallet = _wallet;
        tokenTo = _tokenTo;
        tokenFrom = _tokenFrom;
    }


    function convert( address _from) payable public {
        require(_from != address(0));
        require(msg.value > 0);
tokenTo.mint(_from, msg.value);
        tokenFrom.transfer(msg.value);
        

    }

     //function withdraw(uint amount) external onlyOwner {
       // require(balance >= amount, "Insufficient funds");


        
        //(bool success, ) = msg.sender.call{value: amount}("");
        //require(success, "Transfer failed");
    //}
    function withdraw(uint amount) external onlyOwner {
    require(address(this).balance >= amount, "Insufficient funds");

    (bool success, ) = wallet.call{value: amount}("");
    require(success, "Transfer failed");
}



    // Function to check the contract's Ether balance
    function getBalance() external view override returns (uint256) {
        return address(this).balance;
    }

}
