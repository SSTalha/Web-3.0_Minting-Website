const hre = require("hardhat");

async function main() {

  const RoboPunksNFT = await hre.ethers.getContractFactory("RoboPunksNFT");
  const roboPunksNFT = await Greeter.deploy();

  await roboPunksNFT.deployed();

  console.log("RoboPunksNFT deployed to:", roboPunksNFT.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
