import { ethers } from "ethers";

interface ChainAddresses {
  [contractName: string]: string;
}

const chainIds = {
  ganache: 5777,
  goerli: 5,
  hardhat: 7545,
  kovan: 42,
  mainnet: 1,
  rinkeby: 4,
  bscTestnet: 97,
  bscMainnet: 56,
  MaticTestnet: 80001,
  MaticMainnet: 137,
  ropsten: 3,
};

export const MaticTestnet: ChainAddresses = {
  MaticUSDPriceFeed: "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada",
  feedDecimals: "8",
  usdUpvotePriceInWei: ethers.utils.parseEther("0.1").toString(),
};

export const chainIdToAddresses: {
  [id: number]: { [contractName: string]: string };
} = {
  [chainIds.MaticTestnet]: { ...MaticTestnet },
};
