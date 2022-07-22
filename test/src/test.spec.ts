import { expect } from "chai";
import { Contract, BigNumber, Signer } from "ethers";
import { parseEther } from "ethers/lib/utils";
import hre, { ethers } from "hardhat";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";

describe.only("Call And recive", function () {

  let signers: Signer[];

  let sink: Contract;
  let test:any;



  before(async () => {
    signers = await ethers.getSigners();

    hre.tracer.nameTags[await signers[0].getAddress()] = "ADMIN";
    hre.tracer.nameTags[await signers[1].getAddress()] = "USER1";

    const Sink = await ethers.getContractFactory("Sink", signers[0]);

    sink = await Sink.deploy();

    const Test = await ethers.getContractFactory("Test", signers[0]);

    test = await Test.deploy();
    // hre.tracer.nameTags[sink.address] = "TEST-TOKEN";
  });


  it("should allow  Smart contract and Mint Token", async function () {
    console.log(test.functions)
    console.log(sink.functions)
    await test.callSink(sink.address,({value:parseEther("2")}));
  })


  // it("Check Balance", async function () {
  //   console.log(test.functions)
  //   console.log(sink.functions)

  //   console.log(await sink.check())
  // })


});