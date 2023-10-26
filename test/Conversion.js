const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe('Conversion', function () {
    let owner;
    let user;
    let conversion;
    let tokenFrom;
    let tokenTo;
  
    before(async function () {
      [owner, user] = await ethers.getSigners();
  
      // Deploy ERC20 tokens
      const TokenFrom = await ethers.getContractFactory('ERC20');
      tokenFrom = await TokenFrom.deploy(owner.address, 1000);
  
      const TokenTo = await ethers.getContractFactory('ERC20');
      tokenTo = await TokenTo.deploy(owner.address, 1000);
  
      // Deploy Conversion contract
      const Conversion = await ethers.getContractFactory('Conversion');
      conversion = await Conversion.deploy(owner.address, tokenTo.address, tokenFrom.address);
  
      // Mint tokens for user
      await tokenFrom.connect(owner).transfer(user.address, 100);
    });
  
    it('should allow conversion', async function () {
      // Connect user to Conversion contract
      const conversionUser = conversion.connect(user);
  
      // Approve the Conversion contract to transfer tokensFrom
      await tokenFrom.connect(user).approve(conversion.address, 100);
  
      // Convert tokens
      await conversionUser.convert(user.address, { value: ethers.utils.parseEther('0.1') });
  
      // Check balances
      const tokenFromBalance = await tokenFrom.balanceOf(user.address);
      const tokenToBalance = await tokenTo.balanceOf(user.address);
  
      expect(tokenFromBalance).to.equal(0);
      expect(tokenToBalance).to.equal(ethers.utils.parseEther('0.1'));
    });
  
    it('should allow owner to withdraw', async function () {
      const initialBalance = await ethers.provider.getBalance(owner.address);
      await conversion.connect(owner).withdraw(ethers.utils.parseEther('0.05'));
      const newBalance = await ethers.provider.getBalance(owner.address);
  
      expect(newBalance).to.be.gt(initialBalance);
    });
  });
  