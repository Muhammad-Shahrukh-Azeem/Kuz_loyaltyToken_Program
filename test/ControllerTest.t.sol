// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "lib/forge-std/src/Test.sol";
import "../src/Controller.sol";

contract ControllerTest is Test {
    Controller public controller;
    PhoneBotToken public Pb;

    // address[] public testAddresses = [
    //     address(5),
    //     address(6),
    //     address(7),
    //     address(8)
    // ];
    // uint256[] public tokenValues = [100, 200, 300, 400];

    function setUp() public {
        vm.startPrank(address(1));
        Pb = new PhoneBotToken();
        controller = new Controller(address(Pb));
        vm.stopPrank();
    }

    function testCheckOwner() public {
        assertEq(Pb.owner(), address(1));
        assertEq(controller.owner(), address(1));
    }

    function testBalanceOfOwner() public {
        assertEq(Pb.balanceOf(address(1)), 100000000000000000000);
    }

    function testAddTeam(address _team) public {
        vm.startPrank(address(1));
        Pb.addTeamAddress(_team);
        assert(Pb.teamAccessRecord(_team));
        // console.log(Pb.teamAccessRecord(_team));
    }

    function testRemoveTeamAddress(address _team) public {
        vm.startPrank(address(1));
        Pb.addTeamAddress(_team);
        assert(Pb.teamAccessRecord(_team));
        Pb.removeMemberAddress(_team);
        assert(!Pb.teamAccessRecord(_team));
    }

    function testContractControl() public {
        vm.startPrank(address(1));
        Pb.addTeamAddress(address(2));
        vm.stopPrank();

        vm.startPrank(address(2));
        vm.expectRevert(bytes("This contract Not Allowed"));
        controller.simpleMint(address(6), 69);
        vm.stopPrank();

        vm.startPrank(address(1));
        Pb.addContractAddress(address(controller));
        assert(Pb.teamAccessRecord(address(2)));
        vm.stopPrank();
        // vm.startPrank(address(2));
        // controller.batchMinting(testAddresses, tokenValues);
    }

    function testTeamControl() public {
        vm.expectRevert(bytes("You are not part of team"));
        vm.startPrank(address(2));
        controller.simpleMint(address(2), 50);
    }

    function testTransferTokenOutside(uint256 _amount) public {
        vm.assume(_amount < 10000);
        vm.assume(_amount != 0);

        vm.startPrank(address(1));
        controller.setTaxCollector(address(10));
        Pb.addTeamAddress(address(2));
        Pb.addContractAddress(address(controller));
        assert(Pb.teamAccessRecord(address(2)));
        vm.stopPrank();

        vm.startPrank(address(2));
        Pb.mint(address(3), 10000);
        assertEq(controller.balanceOf(address(3)), 10000);
        vm.stopPrank();

        vm.startPrank(address(3));
        controller.transferingTokensOutside(address(4), _amount);
        uint256 fee = controller.getfee();
        uint256 feeAmount = (_amount * fee) / 10000;
        uint256 transferPercentage = 10000 - fee;
        uint256 transferedAmount = (_amount * transferPercentage) / 10000;
        assertEq(controller.balanceOf(address(4)), transferedAmount);
        console.log("Amount Transfered: ", controller.balanceOf(address(4)));
        assertEq(controller.balanceOf(address(10)), feeAmount);
        console.log(
            "Amount Deducted As Fee: ",
            controller.balanceOf(address(10))
        );
    }

    function testburnOnPurchase(uint256 _amount) public {
        vm.assume(_amount < 10000 && _amount > 0);
        vm.startPrank(address(1));
        Pb.addTeamAddress(address(2));
        Pb.addContractAddress(address(controller));
        assert(Pb.teamAccessRecord(address(2)));
        vm.stopPrank();

        vm.startPrank(address(2));
        uint256 before = controller.balanceOf(address(3));
        controller.simpleMint(address(3), _amount);
        console.log(
            "Balance of address 3 is:",
            controller.balanceOf(address(3))
        );
        vm.stopPrank();

        vm.startPrank(address(3));

        console.log("Approved:", Pb.approve(address(controller), _amount));
        vm.stopPrank();

        console.log(
            "Allowance:",
            Pb.allowance(address(3), address(controller))
        );
        console.log(
            "Allowance to spend",
            controller.allowance(address(3), address(controller))
        );

        vm.startPrank(address(2));
        controller.burnOnPurchase(address(3), _amount);
        uint256 afterr = controller.balanceOf(address(3));
        assertEq(before, afterr);
    }

    function testBuyFeature(uint quantity) public {
        vm.assume(quantity != 0 && quantity <= 10000000);
        vm.startPrank(address(1));
        Pb.addContractAddress(address(controller));
        Pb.enablePurchaseToken();
        vm.stopPrank();

        vm.startPrank(address(3));
        vm.deal(address(3), 100 ether);
        uint256 price = Pb.tokenPrice();
        // console.log(price);
        uint256 totalCost = price * quantity;
        // console.log(totalCost);
        controller.buyTokens{value: totalCost}(address(3), quantity);
        assertEq(controller.balanceOf(address(3)), quantity);
    }

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
}
