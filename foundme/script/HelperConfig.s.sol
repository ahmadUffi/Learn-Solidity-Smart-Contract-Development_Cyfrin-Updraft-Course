// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MocksV3Aggregator.sol";

contract HelperConfig is Script{ 
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }
    constructor() {
        if(block.chainid == 11155111) {
            // Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            // Anvil
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD Price Feed
        });             
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public  returns (NetworkConfig memory) {
        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig; // Return existing config if already set
        }

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8, 2000e8); // 8 decimals, $2000 initial price
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed : address(mockV3Aggregator) // Mock price feed with 8 decimals and initial price of $2000
        });
        return anvilConfig;

    }

}