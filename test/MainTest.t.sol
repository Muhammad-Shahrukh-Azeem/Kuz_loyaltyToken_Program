// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// import "lib/forge-std/src/Test.sol";
// import "../src/Main.sol";

// contract MainTest is Test {
//     Main public main;

//     address[] public testAddresses = [address(5), address(6), address(7), address(8)];
//     uint256[] public tokenValues = [100, 200, 300, 400];

//     function setUp() public {
//         vm.startPrank(address(1));
//         main = new Main();
//         vm.stopPrank();
//     }

//     function testCheckOwner() public {
//         assertEq(main.owner(), address(1));
//     }

//     function testBalanceOfOwner() public {
//         assertEq(main.balanceOf(address(1)), 100000000000000000000);
//     }

//     function testBatchMinting() public {
//         vm.startPrank(address(1));
//         main.addTeamAddress(address(2));
//         vm.stopPrank();
//         vm.startPrank(address(2));
//         // vm.assume(i<600);
//         // vm.assume(testAddresses.length == tokenValues.length);
//         // vm.assume(testAddresses.length < 600 && tokenValues.length < 600);
//         // vm.assume(testAddresses[i] != address(0));
//         main.batchMinting(testAddresses, tokenValues);
//         assertEq(main.balanceOf(address(5)),100);
//         assertEq(main.balanceOf(address(6)),200);
//         assertEq(main.balanceOf(address(7)),300);
//         assertEq(main.balanceOf(address(8)),400);
//         console.log("SuccessFully transferred");
//     }

//     function testAddTeam(address _team) public {
//         vm.startPrank(address(1));
//         main.addTeamAddress(_team);
//         assert(main.getIsTeamMember(_team));
//     }

//     function testRemoveTeamAddress(address _team) public {
//         vm.startPrank(address(1));
//         main.addTeamAddress(_team);
//         assert(main.getIsTeamMember(_team));
//         main.removeMemberAddress(_team);
//         assert(!main.getIsTeamMember(_team));
//     }

//     function testburnOnPurchase(uint _amount) public {
//         vm.assume(_amount < 10000);
//         vm.startPrank(address(1));
//         main.addTeamAddress(address(2));
//         assert(main.getIsTeamMember(address(2)));
//         vm.stopPrank();

//         vm.startPrank(address(2));
//         uint before = main.balanceOf(address(3));
//         main.mint(address(3), _amount);
//         vm.stopPrank();


//         vm.startPrank(address(3));
//         main.approve(address(2), _amount);
//         vm.stopPrank();


//         console.log("Allowance to spend", main.allowance(address(3), address(2)));

//         vm.startPrank(address(2));
//         main.burnOnPurchase(_amount, address(3));
//         uint afterr = main.balanceOf(address(3));
//         assertEq(before, afterr);

//     }

//     function testTransferTokenOutside(uint _amount) public {
//         vm.assume(_amount < 10000);
//         vm.assume(_amount != 0);
//         vm.startPrank(address(1));
//         main.setTaxCollector(address(2));
//         main.addTeamAddress(address(2));
//         assert(main.getIsTeamMember(address(2)));
//         vm.stopPrank();

//         vm.startPrank(address(2));
//         main.mint(address(3), 10000);
//         assertEq(main.balanceOf(address(3)), 10000);
//         vm.stopPrank();

//         vm.startPrank(address(3));
//         main.transferingTokensOutside(address(4), _amount);
//         uint fee = main.getfee();
//         uint feeAmount = (_amount * fee) / 10000;
//         uint transferPercentage = 10000 - fee;
//         uint transferedAmount = (_amount * transferPercentage) / 10000;
//         assertEq(main.balanceOf(address(4)), transferedAmount);
//         assertEq(main.balanceOf(address(2)), feeAmount);
//     }
// }