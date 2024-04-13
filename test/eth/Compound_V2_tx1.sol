//SPDX-License-Identifier: Unlicense
pragma solidity =0.8.19;

import "forge-std/Test.sol";
import "../interface.sol";

// @tx hash: 0xa93bc349561d1f3d834b3c645864a3cb618be747ef4ec66d71c6a5512eeafff6
// @Profit : 10910.69784 $
// Collateralized Token: ETH
// Repaid Token: USDC

contract LiquidationOperator is Test {
    ICompound_v2_cToken public cETH = ICompound_v2_cToken(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
    ICompound_v2_cToken public cUSDC = ICompound_v2_cToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    ICompound_v2_comptroller public comptroller = ICompound_v2_comptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
    address public user = 0x39bDe2F9254cfEf7d0487a27E107Ef6C1685e44c;

    IERC20 public usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    function setUp() public {
        // hash in eth: 0xa93bc349561d1f3d834b3c645864a3cb618be747ef4ec66d71c6a5512eeafff6
        vm.createSelectFork("mainnet", 9120962 - 1);
        vm.label(address(cETH), "cETH");
        vm.label(address(cUSDC), "cUSDC");
        vm.label(address(comptroller), "comptroller");
        vm.label(address(user), "user");
        vm.label(address(usdc), "usdc");

        deal(address(usdc), address(this), type(uint256).max);
    }

    function test_liquidation() public {
        // https://docs.compound.finance/v2/comptroller/#account-liquidity
        // A non-zero liquidity value indicates the account has available account liquidity. 
        // A non-zero shortfall value indicates the account is currently below his/her collateral requirement and is subject to liquidation. 
        (, uint256 liquidity1, uint256 shortfall1) = comptroller.getAccountLiquidity(user);
        require(shortfall1 > 0 && liquidity1 == 0, "Can not be liquidated");

        emit log_named_decimal_uint("[Before] liquidity", liquidity1, 18);
        emit log_named_decimal_uint("[Before] shortfall", shortfall1, 18);
        emit log_named_decimal_uint("[Before] cETH", cETH.balanceOf(address(this)), 8);

        usdc.approve(address(cUSDC), 218213956720);
        cUSDC.liquidateBorrow(user, 218213956720, address(cETH));

        (, uint256 liquidity2, uint256 shortfall2) = comptroller.getAccountLiquidity(user);
        emit log_named_decimal_uint("[After] liquidity", liquidity2, 18);
        emit log_named_decimal_uint("[After] shortfall", shortfall2, 18);
        emit log_named_decimal_uint("[After] cETH", cETH.balanceOf(address(this)), 8);

    }    

}