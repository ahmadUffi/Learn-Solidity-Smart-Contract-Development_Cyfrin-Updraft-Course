// SPDX-Licesnse-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test {
    // This is a placeholder for the test contract.
    // The actual tests will be written in the test/FundMe.t.sol file.
    FundMe public fundMe;
    address UFFI = makeAddr("uffi");
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(UFFI, 100 ether);

    }


    function testMinimumUSD() public view{
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5 ETH");
    }

    function testOwner9() public view {
        assertEq(fundMe.getOwner(), msg.sender, "Owner should be the contract deployer");
    }

    function testGetVersion() public view{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4, "Version should be greater than 0");
    }

  function testFundFailWithoutEnoughEth() public {
    vm.prank(UFFI);
    vm.expectRevert();
    fundMe.fund{value: 0.0001 ether}();

    }

    function testUpdatesFundDataStructr() public {
        vm.prank(UFFI);
        fundMe.fund{value : 6e18}();
        uint amoutFUnded = fundMe.getAddressToAmountFunded(UFFI);
        assertEq(amoutFUnded, 6e18, "Amount funded should be 5 ETH");
    }

    modifier funded(){
        vm.prank(UFFI);
        fundMe.fund{value: 6e18}();
        _;
    }

function testAddsFunderToArray() public funded {
    vm.prank(UFFI);
    fundMe.fund{value: 6e18}();
    address funder = fundMe.getFounder(0);
    assertEq(funder, UFFI, "Funder should be UFFI");
}

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWtihdrawSingleFunder() public funded {
        uint256 initialBalance = fundMe.getOwner().balance;
        uint256 contractBalance = address(fundMe).balance;
        console.log("Initial balance:", initialBalance);
        console.log("Contract balance:", contractBalance);
        uint256 gasStart = gasleft();
        console.log("Gas left before withdrawal:", gasStart);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 finalBalance = fundMe.getOwner().balance;
        console.log("Final balance:", finalBalance);
        assertEq(finalBalance, initialBalance + contractBalance, "Owner should have received the contract balance");

    }

    function testWitddrawMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        for (uint160 i = 1; i < numberOfFunders; i++){
            hoax(address(i), 6e18);
            fundMe.fund{value: 6e18}();
        }

        uint256 initialBalance = fundMe.getOwner().balance;
        uint256 contractBalance = address(fundMe).balance;
        console.log("Initial balance:", initialBalance);
        console.log("Contract balance:", contractBalance);
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        uint256 finalBalance = fundMe.getOwner().balance;
        console.log("Final balance:", finalBalance);
        assertEq(finalBalance, initialBalance + contractBalance, "Owner should have received the contract balance");
    }

        function testWitddrawMultipleFunderscheeper() public funded {
        uint160 numberOfFunders = 10;
        for (uint160 i = 1; i < numberOfFunders; i++){
            hoax(address(i), 6e18);
            fundMe.fund{value: 6e18}();
        }

        uint256 initialBalance = fundMe.getOwner().balance;
        uint256 contractBalance = address(fundMe).balance;
        console.log("Initial balance:", initialBalance);
        console.log("Contract balance:", contractBalance);
        vm.startPrank(fundMe.getOwner());
        fundMe.withdrawCheeper();
        vm.stopPrank();
        uint256 finalBalance = fundMe.getOwner().balance;
        console.log("Final balance:", finalBalance);
        assertEq(finalBalance, initialBalance + contractBalance, "Owner should have received the contract balance");
    }
}