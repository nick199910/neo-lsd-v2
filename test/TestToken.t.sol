// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StNEO} from "src/stNEO.sol";
import {WstNEO, ERC20} from "src/wstNEO.sol";

contract TokenTest is Test {
    address owner = address(0x01);
    address user1 = address(0x02);
    address user2 = address(0x03);
    uint256 start = 1721475062;

    StNEO stNEO;
    WstNEO wstNEO;

    function setUp() public {
        vm.startPrank(owner);

        vm.warp(1721475062);
        stNEO = new StNEO("stNEO", "stNEO", 18);
        wstNEO = new WstNEO(ERC20(address(stNEO)), 120);
        stNEO.mint(user1, 10 ether);
        stNEO.mint(user2, 10 ether);
        stNEO.mint(address(this), 100 ether);
    
        vm.stopPrank();
    }

    function test_restake() public {
        stNEO.transfer(address(wstNEO), 1);

        vm.startPrank(user1);
        stNEO.approve(address(wstNEO), 4 ether);
        wstNEO.deposit(4 ether, user1);
        vm.stopPrank();

        vm.startPrank(user2);
        stNEO.approve(address(wstNEO), 4 ether);
        wstNEO.deposit(2 ether, user2);
        vm.stopPrank();
        console.log("\n before rewards release: ================================== user token balance \n");

        console.log("user1 stNEO balance: ", stNEO.balanceOf(user1));
        console.log("user1 wstNEO balance: ", wstNEO.balanceOf(user1));
        console.log("user2 stNEO balance: ", stNEO.balanceOf(user2));
        console.log("user2 wstNEO balance: ", wstNEO.balanceOf(user2));
   

      
        stNEO.transfer(address(wstNEO), 12 ether);
        vm.warp(start + 120);
        wstNEO.syncRewards();
        stNEO.transfer(address(wstNEO), 1);
        vm.warp(start + 240);
        wstNEO.syncRewards();

        console.log("\n after rewards released: ================================== user token balance \n");

        vm.startPrank(user1);
        wstNEO.redeem(wstNEO.balanceOf(user1), user1, user1);
        console.log("user1 stNEO balance: ", stNEO.balanceOf(user1));
        console.log("user1 wstNEO balance: ", wstNEO.balanceOf(user1));
        vm.stopPrank();


        vm.startPrank(user2);
        wstNEO.redeem(wstNEO.balanceOf(user2), user2, user2);
        console.log("user2 stNEO balance: ", stNEO.balanceOf(user2));
        console.log("user2 wstNEO balance: ", wstNEO.balanceOf(user2));
        vm.stopPrank();


    }
}
