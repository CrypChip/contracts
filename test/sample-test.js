const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CrypChip", function () {
  it("Should create a new group and return user membership data", async function () {
    const CrypChip = await ethers.getContractFactory("CrypChip");
    const crypchip = await CrypChip.deploy();
    await crypchip.deployed();


    const createGroupTx = await crypchip.createGroup("Group1", ["0x420674Af540BE70031cbdE8C9279fA4fF4b049CE", "0xb8761b30c951d0614459b2e227Ea944df0314665"]);

    // wait until the transaction is mined
    await createGroupTx.wait();

    const groupData = await crypchip.getGroups("0x420674Af540BE70031cbdE8C9279fA4fF4b049CE");
    expect(groupData[0].gId).to.equal(1);
  });

  it("Should create a new group, add expense and return expense data", async function () {
    //TODO
    const CrypChip = await ethers.getContractFactory("CrypChip");
    const crypchip = await CrypChip.deploy();
    await crypchip.deployed();


    const createGroupTx = await crypchip.createGroup("Group1", ["0x420674Af540BE70031cbdE8C9279fA4fF4b049CE", "0xb8761b30c951d0614459b2e227Ea944df0314665"]);

    // wait until the transaction is mined
    await createGroupTx.wait();

    const groupData = await crypchip.getGroups("0x420674Af540BE70031cbdE8C9279fA4fF4b049CE");
    expect(groupData[0].gId).to.equal(1);
  });

});
