async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const deployerBalance = await deployer.getBalance();
  console.log("deployer address: ", deployer.address);
  console.log("deployer balance: ", deployerBalance.toString());

  const WaveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await WaveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });
  await waveContract.deployed();
  console.log("contract deployed to: ", waveContract.address);
}

async function runMain() {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

runMain();
