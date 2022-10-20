// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../node_modules/@openzeppelin/contracts/security/Pausable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract PhoneBotToken is ERC20, ERC20Burnable, Pausable, Ownable {
    error Insufficient_Balance();
    error CannotBeAddressZero();
    error AlreadyAdded();
    error AlreadyRemoved();

    bool public allowNativeFunctionality = false;

    mapping(address => bool) public teamAccessRecord;
    mapping(address => bool) public contractAccess;

    modifier onlyTeam() {
        require(teamAccessRecord[msg.sender], "You are not part of team");
        _;
    }

    modifier whenNativeFuncAllowed() {
        require(allowNativeFunctionality, "This is not allowed yet");
        _;
    }

    modifier onlyAllowedContracts() {
        require(contractAccess[msg.sender], "This contract Not Allowed");
        _;
    }

    constructor() ERC20("PhoneBotToken", "PBT") {
        _mint(msg.sender, 100 * 10**decimals());
    }

    function setNativeFunctionality(bool _permission) external onlyOwner {
        allowNativeFunctionality = _permission;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyTeam whenNotPaused {
        _mint(to, amount);
    }

    function mintForContract(address to, uint256 amount)
        public
        onlyAllowedContracts
        whenNotPaused
    {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        whenNativeFuncAllowed
        onlyAllowedContracts
        returns (bool)
    {
        address sender = _msgSender();
        _transfer(sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    )
        public
        virtual
        override
        whenNativeFuncAllowed
        onlyAllowedContracts
        returns (bool)
    {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @notice This function can be called by the controller
     * @param from Address that is sending
     * @param to Address that is recieving
     * @param amount The quantity of these tokens
     */
    function transferFunds(
        address from,
        address to,
        uint256 amount
    ) public onlyAllowedContracts {
        if (balanceOf(from) < amount) {
            revert Insufficient_Balance();
        }
        if (from == address(0) || to == address(0)) {
            revert CannotBeAddressZero();
        }
        _transfer(from, to, amount);
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        onlyAllowedContracts
        returns (bool)
    {
        address sender = _msgSender();
        _approve(sender, spender, amount);
        return true;
    }

    /**
     * @notice Method for adding contract addresses
     * @param _contract Address of controller contract
     */
    function addContractAddress(address _contract) external onlyOwner {
        if (contractAccess[_contract]) {
            revert AlreadyAdded();
        }
        contractAccess[_contract] = true;
    }

    /**
     * @notice Method for Removing contract addresses
     * @param _contract Address of controller contract
     */
    function removeContractAddress(address _contract) external onlyOwner {
        if (!contractAccess[_contract]) {
            revert AlreadyAdded();
        }
        contractAccess[_contract] = true;
    }

    /**
     * @notice Method for adding team members
     * @param _member Address of team member
     */
    function addTeamAddress(address _member) external onlyOwner {
        if (teamAccessRecord[_member]) {
            revert AlreadyRemoved();
        }
        teamAccessRecord[_member] = true;
    }

    /**
     * @notice Method for removing team members
     * @param _member Address of team member
     */
    function removeMemberAddress(address _member) external onlyOwner {
        teamAccessRecord[_member] = false;
    }
}
