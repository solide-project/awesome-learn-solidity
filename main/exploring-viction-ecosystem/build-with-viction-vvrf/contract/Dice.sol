// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

interface IVRRF {
    /**
     * @notice Get pseudo-random number base on provided seed
     * @param salt Random data as an additional input to harden the random
     */
    function random(bytes32 salt) external view returns (bytes32);
}

/**
 * @dev Following VRRF address in Viction:
 * @notice Mainnet: 0x53eDcf19e4fb242c9957CB449d2d4106fD760A7F
 * @notice Testnet: 0xDb14c007634F6589Fb542F64199821c3308A9d92
 */
contract Dice {
    IVRRF public immutable vvrf;

    constructor(address _vvrf) {
        vvrf = IVRRF(_vvrf);
    }

    function roll() public view returns (uint8) {
        bytes32 salt = blockhash(block.number - 1);
        uint256 n = uint256(vvrf.random(salt));
        return uint8((n % 6) + 1);
    }

    function rollWithSalt(bytes32 salt) public view returns (uint8) {
        uint256 n = uint256(vvrf.random(salt));
        return uint8((n % 6) + 1);
    }
}
