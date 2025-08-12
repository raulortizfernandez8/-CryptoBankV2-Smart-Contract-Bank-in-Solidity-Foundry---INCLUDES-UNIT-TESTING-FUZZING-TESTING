// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "../src/CryptoBankV2.sol";
import "forge-std/Test.sol";

contract CryptoBankV2Test is Test{

    CryptoBankV2 cryptoBankV2;
     uint256 public maxBalance = 50000000000000000000;
     address public admin = vm.addr(1);
     mapping (address => uint256) public userBalance;
     address public randomUser = vm.addr(2);
   

    function setUp() public {
        cryptoBankV2 = new CryptoBankV2(maxBalance,admin);
    }

    // Unit Texting. Given values.
    function testMaxBalance() public view{
        uint256 maxBalance_ = cryptoBankV2.maxBalance();
        assert(maxBalance_==maxBalance);
    }

    function testDepositEther() public{
        cryptoBankV2.depositEther{value: 1 ether}();
    }

    function testDepositEtherWhenNotActiveReverts() public{
        vm.startPrank(admin);

        cryptoBankV2.disableBank();
        vm.expectRevert();
        cryptoBankV2.depositEther();

        vm.stopPrank();
    }
    
    function testWithDrawEther() public{
        vm.startPrank(admin);

        vm.deal(address(cryptoBankV2), 5 ether);
        uint256 slotBase = 3;
        uint256 amount_ = 3 ether;
        // Calculamos la posición exacta en storage para userBalance[user]
        bytes32 storageSlot = keccak256(abi.encode(admin, uint256(slotBase)));
        vm.store(address(cryptoBankV2), storageSlot, bytes32(amount_)); 
        cryptoBankV2.withDrawEther(1 ether);

        vm.stopPrank();
    }

    function testChangeMaxBalanceWhenNotAdminReverts() public{
        vm.startPrank(randomUser);

        uint256 newMaxBalance_ = 80000000000000000000;
        vm.expectRevert();
        cryptoBankV2.modifyMaxBalance(newMaxBalance_);

        vm.stopPrank();
    }
    function testChangeMaxBalanceWhenAdmin() public{
        vm.startPrank(admin);

        uint256 newMaxBalance_ = 80000000000000000000;
        cryptoBankV2.modifyMaxBalance(newMaxBalance_);

        vm.stopPrank();
    }
    function testChangeComisionWhenNotAdminReverts() public{
        vm.startPrank(randomUser);

        uint256 newComision_ = 3;
        vm.expectRevert();
        cryptoBankV2.modifyMaxBalance(newComision_);

        vm.stopPrank();
    }
    function testChangeComisionWhenAdmin() public{
        vm.startPrank(admin);

        uint256 newComision_ = 3;
        cryptoBankV2.modifyMaxBalance(newComision_);

        vm.stopPrank();
    }
    function testEnableBankWhenAdmin() public {
        vm.startPrank(admin);

        cryptoBankV2.enableBank();

        vm.stopPrank();
    }
    function testEnableBankWhenNotAdminReverts() public {
        vm.startPrank(randomUser);

        vm.expectRevert();
        cryptoBankV2.enableBank();

        vm.stopPrank();
    }
    function testDisableBankWhenAdmin() public {
        vm.startPrank(admin);

        cryptoBankV2.disableBank();

        vm.stopPrank();
    }
    function testDisableBankWhenNotAdminReverts() public {
        vm.startPrank(randomUser);

        vm.expectRevert();
        cryptoBankV2.disableBank();

        vm.stopPrank();
    }
    function testWithDrawBankBalanceWhenNotAdmin() public{
        vm.startPrank(randomUser);

        vm.expectRevert();
        cryptoBankV2.withDrawBankBalance();

        vm.stopPrank();
    }
       function testWithDrawBankBalanceWhenAdmin() public{

         vm.startPrank(admin);
        // Force bankBalance = 10
        bytes32 slot = bytes32(uint256(0)); // storage slot for bankBalance
        vm.store(address(cryptoBankV2), slot, bytes32(uint256(4 ether)));
        vm.deal(address(cryptoBankV2), 4 ether);
        cryptoBankV2.withDrawBankBalance();

        vm.stopPrank();
    }

    // Fuzzing Testing. Random Inputs.
     function testFuzzingChangeMaxBalanceWhenAdmin(uint256 newMaxBalance_) public{
        vm.startPrank(admin);

        cryptoBankV2.modifyMaxBalance(newMaxBalance_);

        vm.stopPrank();
    }  


}
