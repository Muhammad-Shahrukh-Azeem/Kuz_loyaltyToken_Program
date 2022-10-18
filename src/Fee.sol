// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Fee is Ownable {
    uint256 internal fee = 2000; // This is 20% in BIPS

    event feeUpdated(uint256 feeBefore, uint256 feeAfter);

    /**
     * @notice Method setting and Updating fee
     * @param _fee new listing fee
     */

    function setFee(uint256 _fee) external onlyOwner {
        fee = _fee;
        emit feeUpdated(fee, _fee);
    }

    /**
     * @notice Method for Calculating amount After fee deduction
     * @param _AmountToTransfer This is the amount the user wants to transfer
     */
    function calculateAfterfeeDeduction(uint256 _AmountToTransfer)
        internal
        view
        returns (uint256)
    {
        uint256 percentageToTransfer = 10000 - fee;
        return ((_AmountToTransfer * percentageToTransfer) / 10000);
    }

    /**
     * @notice Method for Calculating amount After fee deduction
     * @param _AmountToTransfer This is the amount the user wants to transfer
     */
    function calculateFeeForAmount(uint256 _AmountToTransfer)
        internal
        view
        returns (uint256)
    {
        return ((_AmountToTransfer * fee) / 10000);
    }
    function getfee() external view returns (uint256) {
        return fee;
    }
}
