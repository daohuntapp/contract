// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UpvoteERC1155 is ERC1155(""), Ownable {
    uint256 public tokenIdCounter;

    string public constant name = "DAOHunt Upvote";
    string public constant symbol = "DHNT UPVT";

    address public daoHunt;

    function mint(uint256 id, address to) external {
        require(msg.sender == daoHunt, "Not Authorized");
        _mint(to, id, 1, "");
    }

    function setDAOHunt(address _daoHunt) external onlyOwner {
        daoHunt = _daoHunt;
    }
}
