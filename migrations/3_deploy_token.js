const Townhall = artifacts.require("Townhall");
const Lumberjack = artifacts.require("Lumberjack");
const MainContract = artifacts.require('MainContract');

module.exports = async function (deployer) {
  await deployer.deploy(Townhall, "http://localhost:3000/api/tokens");

  const townhallInstance = await Townhall.deployed();

  await deployer.deploy(Lumberjack, "http://localhost:3000/api/tokens");

  const lumberJackInstance = await Lumberjack.deployed();

  await deployer.deploy(MainContract);
  
  const mainInstance = await MainContract.deployed();


  mainInstance.setTownhall(Townhall.address);
  mainInstance.setLumberjack(Lumberjack.address);

  townhallInstance.setFatherContract(MainContract.address);
  lumberJackInstance.setFatherContract(MainContract.address);
};
