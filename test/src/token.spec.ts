import { expect } from "chai";
import { Contract, BigNumber, Signer } from "ethers";
import { parseEther } from "ethers/lib/utils";
import hre, { ethers } from "hardhat";

describe("Market Token", function () {

  let signers: Signer[];

  let testTokenInstance: Contract;
  let masterNFT:any;



  before(async () => {
    signers = await ethers.getSigners();

    hre.tracer.nameTags[await signers[0].getAddress()] = "ADMIN";
    hre.tracer.nameTags[await signers[1].getAddress()] = "USER1";

    const Market = await ethers.getContractFactory("Market", signers[0]);

    testTokenInstance = await Market.deploy();

    const NFT = await ethers.getContractFactory("NFT", signers[0]);

    masterNFT = await NFT.deploy();
    hre.tracer.nameTags[testTokenInstance.address] = "TEST-TOKEN";
  });


  it("should allow  Smart contract and Mint Token", async function () {
    console.log(masterNFT.functions)
    console.log(testTokenInstance.functions)
    await masterNFT.setApprovalForAll(testTokenInstance.address,true);

    await masterNFT.safeMint();
    await masterNFT.safeMint();
  })

  it("Create List", async function () {
    await testTokenInstance.listToken(masterNFT.address,0,parseEther("1"));
    await testTokenInstance.listToken(masterNFT.address,1,parseEther("1"));
  })

  it("Get List", async function () {
    console.log(await testTokenInstance.getListing(1));
    await testTokenInstance.getListing(1)
  })

  it("Seller cannot be buyer", async function () {
    // console.log(await testTokenInstance.getListing(1));
    await expect(testTokenInstance.buyToken(1)).to.be.revertedWith("Seller cannot be buyer")
  })

  it("buyer Don't have Enough Ether", async function () {
    // console.log(await testTokenInstance.getListing(1));
    await expect(testTokenInstance.connect(signers[1]).buyToken(1)).to.be.revertedWith("Insufficient payment")
  })


  it("buy Token", async function () {
    // console.log(await testTokenInstance.getListing(1));
    await testTokenInstance.connect(signers[1]).buyToken(1,({value:parseEther("1")}))
  })

  it("Seller can Cancel List", async function () {
    // console.log(await testTokenInstance.getListing(1));
    await expect(testTokenInstance.connect(signers[1]).cancel(1)).to.be.revertedWith("Only seller can cancel listing")
  })


  it("Seller can Cancel ", async function () {
    // console.log(await testTokenInstance.getListing(1));
    await testTokenInstance.cancel(2)
  })



});