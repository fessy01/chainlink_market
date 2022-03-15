import { ethers } from "hardhat";
async function TestChainlink() {

    const ChainMarket = await ethers.getContractFactory("ChainMarket");
    const chainMarket = await ChainMarket.deploy();

    await chainMarket.deployed();

    console.log("ChainMarket deployed to:", chainMarket.address);
  }

  TestChainlink().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });