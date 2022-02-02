const { ethers } = require("hardhat");
// const skipIf = require('mocha-skip-if')
const chai = require('chai')
const { expect } = require('chai')
const BN = require('bn.js')
// chai.use(require('chai-bn')(BN))
// const { LinkToken } = require('@chainlink/contracts/truffle/v0.6/LinkToken');
// const LotteryContract = artifacts.require('Lottery');

describe("Lottery contract", function () {

  let Lottery;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  // Represents 1 LINK for testnet requests
  const payment = web3.utils.toWei('1')

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.    
    const [owner, addr1, addr2, addr3] = await ethers.getSigners();
    
    // const LotteryContract = await ethers.getContractFactory("Lottery");

    //  // To deploy our contract, we just have to call Lottery.deploy() and await
    // // for it to be deployed(), which happens once its transaction has been
    // // mined.
    Lottery = await LotteryContract.new( { from: owner });

    await Lottery.deployed();
  
  });

   // You can nest describe calls to create subsections.
   describe("Deployment", function () {
    // `it` is another Mocha function. This is the one you use to define your
    // tests. It receives the test name, and a callback function.

    // If the callback function is async, Mocha will `await` it.
    it("Should set the right owner", async function () {
      // Expect receives a value, and wraps it in an Assertion object. These
      // objects have a lot of utility methods to assert values.

      // This test expects the owner variable stored in the contract to be equal
      // to our Signer's owner.
      expect(await Lottery.admin()).to.equal(owner.address);
    });

    it("Top up Contract address with LINK tokens", async function () {

      // await link.transfer(Lottery.address, web3.utils.toWei('1', 'ether'), {
      //   from: owner,
      // });
    });
  });

  describe("Lottery System", function () {
    // `it` is another Mocha function. This is the one you use to define your
    // tests. It receives the test name, and a callback function.
    
    it("Start a new Lottery", async function () {

      await Lottery.startNewLottery({from:owner});

      expect(await Lottery.state()).to.equal(LotteryState.Open);
    });

    it("Enter into Lottery", async function(){

      

    })

    it("check state", async function(){


    })
});
});
