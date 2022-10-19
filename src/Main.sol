// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

// import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
// import "./Loyalty.sol";
// import "./Fee.sol";
// import "./PhoneBotToken.sol";

// // The name Main will be changed to the project name
// contract Main is Fee, Loyalty, PhoneBotToken {
//     using Counters for Counters.Counter;

//     uint256 public lockTIme;
//     address public taxCollector;

//     error AlreadyAdded();
//     error AddressAndAmountLengthInvalid();
//     error NotEnoughBalance();
//     error CannotBeAddressZero();
//     error CannotSendToAddressZero();
//     error valueCannotBeZero();
//     error cannotBeContract();

//     event TokenRewarded(address to, uint256 amount);

//     event TokensBurned(uint256 amount, address user);

//     /**
//      * @notice Method for security to ensure that address is not of a contract
//      * @param _addr input address
//      */
//     function isContract(address _addr) internal view returns (bool) {
//         uint256 size;
//         assembly {
//             size := extcodesize(_addr)
//         }
//         return size > 0;
//     }


//     /**
//      * @notice Method for adding team members
//      * @param _member Address of team member
//      */
//     function addTeamAddress(address _member) external onlyOwner {
//         if (teamAccessRecord[_member]) {
//             revert AlreadyAdded();
//         }
//         teamAccessRecord[_member] = true;
//     }

//     /**
//      * @notice Method for adding _taxCollector
//      * @param _taxCollector Address of treasy where fee will be collected
//      */
//     function setTaxCollector(address _taxCollector) external onlyOwner {
//         if (isContract(_taxCollector)) {
//             revert cannotBeContract();
//         }
//         taxCollector = _taxCollector;
//     }

//     /**
//      * @notice Method for removing team members
//      * @param _member Address of team member
//      */
//     function removeMemberAddress(address _member) external onlyOwner {
//         teamAccessRecord[_member] = false;
//         delete teamAccessRecord[_member];
//     }

//     /**
//      * @notice Method for Rewarding to all winners.
//      * @param _addresses array of addresses to which the amount will go
//      * @param _amounts array of amounts which will be awarded
//      */

//     function batchMinting(
//         address[] memory _addresses,
//         uint256[] memory _amounts
//     ) external onlyTeam whenNotPaused {
//         if (_addresses.length != _amounts.length) {
//             revert AddressAndAmountLengthInvalid();
//         }

//         for (uint256 i = 0; i < _addresses.length; i++) {
//             if (_addresses[i] == address(0)) {
//                 revert CannotBeAddressZero();
//             }

//             _mint(_addresses[i], _amounts[i]);

//             emit TokenRewarded(_addresses[i], _amounts[i]);
//         }
//     }

//     // CALL APPROVE BEFORE CALLING THIS FUNCTION, approval will be for teammember

//     function burnOnPurchase(uint256 _amount, address _user)
//         external
//         onlyTeam
//         whenNotPaused
//     {
//         if (balanceOf(_user) < _amount) {
//             revert NotEnoughBalance();
//         }
//         burnFrom(_user, _amount);
//         emit TokensBurned(_amount, _user);
//     }

//     /**
//      * @notice This function deducts tokens when transferring outside.
//      * @param _to Address that they are sending to.
//      * @param _amount The number of tokens to be transfered
//      */
//     function transferingTokensOutside(address _to, uint256 _amount) external {
//         if (_to == address(0)) {
//             revert CannotSendToAddressZero();
//         }
//         if (_amount <= 0) {
//             revert valueCannotBeZero();
//         }
//         uint256 amount = calculateAfterfeeDeduction(_amount);
//         uint FeeAmount = calculateFeeForAmount(_amount);
//         address sender = _msgSender();
//         _transfer(sender, taxCollector, FeeAmount);
//         _transfer(sender, _to, amount);
//     }

//     function getIsTeamMember(address _team) public view returns (bool) {
//         return teamAccessRecord[_team];
//     }

//     function getTaxCollectorAddress() external view onlyOwner returns(address){
//         return taxCollector;
//     }
// }
