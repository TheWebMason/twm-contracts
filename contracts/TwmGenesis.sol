// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721A.sol";
import "./ITwmPresale.sol";

contract TwmGenesis is Ownable, ERC721A {
    address public presale;

    // Mapping from token ID to level
    mapping(uint256 => uint8) internal _levels;

    constructor() ERC721A("TheWebMason Genesis", "TWM-") {
        //
    }
}
