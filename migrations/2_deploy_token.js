const townhall = artifacts.require("Townhall");
const Lumberjack = artifacts.require("Lumberjack");

module.exports = async function (deployer) {
  await deployer.deploy(townhall, "http://localhost:3000/api/tokens");

  await deployer.deploy(Lumberjack, "http://localhost:3000/api/tokens");
};
