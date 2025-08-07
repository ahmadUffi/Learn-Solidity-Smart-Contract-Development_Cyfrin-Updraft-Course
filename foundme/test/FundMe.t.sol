// SPDX-Licesnse-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test {
    // This is a placeholder for the test contract.
    // The actual tests will be written in the test/FundMe.t.sol file.
    FundMe public fundMe;
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }


    function testMinimumUSD() public view{
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5 ETH");
    }

    function testOwner9() public view {
        assertEq(fundMe.i_owner(), msg.sender, "Owner should be the contract deployer");
    }

    function testGetVersion() public view{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4, "Version should be greater than 0");
    }
}