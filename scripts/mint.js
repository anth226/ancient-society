const HDWalletProvider = require("@truffle/hdwallet-provider");
const web3 = require("web3");
const fs = require("fs");
const path = require("path");
require("dotenv").config();

//*vars
const PRIVATE_ADDRESS = process.env.PRIVATE_ADDRESS;
const TRUFFLE = process.env.TRUFFLE;

//* Remember to write the nft address in manually after deploying the contract
const NFT_CONTRACT_ADDRESS = "0x5ccf3df398B8471Fe539a535Af2FCA86c6D0E3BA";
const OWNER_ADDRESS = "0x45f2D2Ab98cF626592a606CE6f40F5762E1b82dE";
const NUM_ITEMS = 5;

//*Parse the contract artifact for ABI reference.
let rawdata = fs.readFileSync(
  path.resolve(__dirname, "../build/contracts/Townhall.json")
);
let contractAbi = JSON.parse(rawdata);
const NFT_ABI = contractAbi.abi;

async function main() {
  try {
    //*define web3, contract and wallet instances
    const provider = new HDWalletProvider(PRIVATE_ADDRESS, TRUFFLE);

    const web3Instance = new web3(provider);

    const nftContract = new web3Instance.eth.Contract(
      NFT_ABI,
      NFT_CONTRACT_ADDRESS
    );

    const accounts = await web3Instance.eth.getAccounts();
    console.log(accounts[0]);
    //* just mint
    await nftContract.methods
      .mint(accounts[0])
      .send({ from: accounts[0] })
      .then(console.log("minted"))
      .catch((error) => console.log(error));

    //* mint for a certain amount
    /*
    for (var i = 1; i < NUM_ITEMS; i++) {
      await nftContract.methods
        .mintItem(OWNER_ADDRESS, `https://ipfs.io/ipfs/QmZ13J2TyXTKjjyA46rYENRQYxEKjGtG6qyxUSXwhJZmZt/${i}.json`)
        .send({ from: OWNER_ADDRESS }).then(console.log('minted')).catch(error => console.log(error));
    }
    */
  } catch (e) {
    console.log(e);
  }
}

//invoke
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
