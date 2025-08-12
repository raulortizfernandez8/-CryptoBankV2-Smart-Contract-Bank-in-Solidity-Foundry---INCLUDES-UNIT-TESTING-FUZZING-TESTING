# 🏦 CryptoBankV2 – Smart Contract Bank in Solidity (Foundry) - INCLUDES UNIT TESTING & FUZZY TESTING
CryptoBankV2 is a Solidity smart contract simulating a multi-user Ethereum bank with deposits, withdrawals, configurable maximum balances, commission fees, and emergency stop functionality.
The project includes unit tests and fuzz testing using Foundry.

# 📜 Features & Rules
Multi-user support – multiple accounts can interact with the bank.

Ether-only deposits – ERC20 tokens are not supported.

User isolation – a user can only withdraw their own funds.

Maximum balance per user – default limit (modifiable by admin).

Configurable maximum balance – only modifiable by the admin.

Commission fees – percentage taken from deposits & withdrawals, adjustable by admin.

Emergency stop (circuit breaker) – admin can disable or enable the bank.

Bank fee withdrawals – admin can withdraw accumulated commission fees.

# ⚙️ Contract Overview
State Variables
uint256 bankBalance → Total accumulated fees (bank's balance).

uint256 public maxBalance → Maximum allowed user balance (in Wei).

address public admin → Address with admin privileges.

mapping(address => uint256) public userBalance → User’s personal Ether balance.

bool public bankActive → Bank status (true = active, false = disabled).

uint256 comision → Commission percentage (max 10%).

# Key Functions
Function	Description	Access
depositEther()	Deposit Ether into your account (fees apply).	Active bank
withDrawEther(uint256 amount)	Withdraw your own Ether (fees apply).	Active bank
changeComision(uint256 newComision)	Change commission percentage (≤ 10%).	Admin only
modifyMaxBalance(uint256 newMaxBalance)	Change max allowed user balance.	Admin only
disableBank()	Disable all deposits & withdrawals.	Admin only
enableBank()	Re-enable deposits & withdrawals.	Admin only
withDrawBankBalance()	Withdraw all accumulated fees from bankBalance.	Admin only

# 🧪 Testing
Tests are implemented in Foundry and cover:

✅ Unit Tests (Given Values)
Max Balance Check

testMaxBalance() – ensures the deployed maxBalance matches expected value.

Deposits

testDepositEther() – successful deposit of 1 ether.

testDepositEtherWhenNotActiveReverts() – deposit fails when the bank is disabled.

Withdrawals

testWithDrawEther() – successful withdrawal when user balance is preloaded in storage.

Modify Max Balance

testChangeMaxBalanceWhenNotAdminReverts() – non-admin cannot change max balance.

testChangeMaxBalanceWhenAdmin() – admin can change max balance.

Change Commission

testChangeComisionWhenNotAdminReverts() – non-admin cannot change commission.

testChangeComisionWhenAdmin() – admin can change commission.

Enable/Disable Bank

testEnableBankWhenAdmin() – admin can enable bank.

testEnableBankWhenNotAdminReverts() – non-admin cannot enable bank.

testDisableBankWhenAdmin() – admin can disable bank.

testDisableBankWhenNotAdminReverts() – non-admin cannot disable bank.

Withdraw Bank Balance

testWithDrawBankBalanceWhenNotAdmin() – non-admin cannot withdraw bank balance.

testWithDrawBankBalanceWhenAdmin() – admin can withdraw when bankBalance > 0 (manually set via vm.store).

🎲 Fuzz Testing (Random Inputs)
Max Balance

testFuzzingChangeMaxBalanceWhenAdmin(uint256) – verifies admin can set maxBalance to arbitrary values without revert.

