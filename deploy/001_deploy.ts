import { HardhatRuntimeEnvironment, Network } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { chainIdToAddresses } from "../networkVariables";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy, execute } = deployments;

  const { deployer } = await getNamedAccounts();
  // get current chainId
  const chainId = parseInt(await hre.getChainId());
  const addresses = chainIdToAddresses[chainId];

  const upvoteERC1155 = await deploy("UpvoteERC1155", {
    from: deployer,
    log: true,
  });
  const daoHunt = await deploy("DAOHuntERC721", {
    args: [
      upvoteERC1155.address,
      addresses.MaticUSDPriceFeed,
      addresses.feedDecimals,
      addresses.usdUpvotePriceInWei,
      deployer,
    ],
    from: deployer,
    log: true,
  });
  await execute(
    "UpvoteERC1155",
    {
      from: deployer,
      log: true,
    },
    "setDAOHunt",
    daoHunt.address
  );
};
export default func;
func.tags = ["UpvoteERC1155"];
