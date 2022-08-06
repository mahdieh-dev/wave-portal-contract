async function main() {
  const [owner, Saeed] = await hre.ethers.getSigners();
  const WaveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await WaveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("contract is deployed to: ", waveContract.address);
  console.log("this person deployed the contract: ", owner);
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance is: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let totalWaveCount = await waveContract.totalWaveCount();
  console.log("Now wave count is %s", totalWaveCount);

  let waveFunctionCall = await waveContract.wave(1, "Mahdieh");
  await waveFunctionCall.wait();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Now contract balance is: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  totalWaveCount = await waveContract.totalWaveCount();
  console.log("Now wave count currently is %s", totalWaveCount);

  waveFunctionCall = await waveContract.connect(Saeed).wave(26, "Saeed");
  await waveFunctionCall.wait();

  totalWaveCount = await waveContract.totalWaveCount();
  console.log("Now wave count currently is %s", totalWaveCount);

  const [waverName, waverAddress, waverCount] =
    await waveContract.whoWavesTheMost();
  console.log(
    "%s with the address %s has waved at you %d times!",
    waverName,
    waverAddress,
    waverCount
  );

  const allWaves = await waveContract.getAllWaves();
  console.log("Here are all waves: ", allWaves);
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
