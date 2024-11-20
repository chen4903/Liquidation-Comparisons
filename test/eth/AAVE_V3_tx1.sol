//SPDX-License-Identifier: Unlicense
pragma solidity =0.8.19;

import "forge-std/Test.sol";
import "../interface.sol";

// @tx hash: 0x35240526c70a5bcfe2d7fd5bc5ba668ca3a490c4a135650fb892e70f1f0a0f1d
// Debt Asset: USDC
// DebtToCover: 5,887.3642
// Liquidation Asset: WETH
// Liquidation Amount: 1.9480

contract LiquidationOperator is Test {

    IERC20 public usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IWETH weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IPancakeV3Pool public pancakeV3Pool = IPancakeV3Pool(0x1ac1A8FEaAEa1900C4166dEeed0C11cC10669D36);
    IAavePoolV3 public aavePoolV3 = IAavePoolV3(0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2);
    address user = 0x3d025d18fbEC14e4A398bC5C5AF86d3C46DA1825;
    uint256 public DEBT_ASSET_USDC_AMOUNT = 5887364178;

    function setUp() public {
        vm.createSelectFork("mainnet", 21218344);
        // check: https://etherscan.io/txs?block=21218344&p=4
        // back run: 0x51b477943b161e0ee0949502d3431e6f47861f0985fc7690d404e4063ae990d8
        vm.rollFork(bytes32(0x35240526c70a5bcfe2d7fd5bc5ba668ca3a490c4a135650fb892e70f1f0a0f1d));
        deal(address(weth), address(this), 0);
    }

    function test_liquidation() public {
        emit log_named_decimal_uint(
            "[Before liquidation], usdc", usdc.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "[Before liquidation], weth", weth.balanceOf(address(this)), 18
        );

        (uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = aavePoolV3.getUserAccountData(user);

        emit log_named_decimal_uint(
            "[Before liquidation],  healthFactor", healthFactor, 18
        );

        pancakeV3Pool.swap(address(this), false, -int256(DEBT_ASSET_USDC_AMOUNT), 1461446703485210103287273052203988822378723970341, "");

        emit log_named_decimal_uint(
            "[After liquidation],  usdc", usdc.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "[After liquidation],  weth", weth.balanceOf(address(this)), 18
        );

        (totalCollateralBase,
            totalDebtBase,
            availableBorrowsBase,
            currentLiquidationThreshold,
            ltv,
            healthFactor
        ) = aavePoolV3.getUserAccountData(user);

        emit log_named_decimal_uint(
            "[After liquidation],  healthFactor", healthFactor, 18
        );
    }

    function pancakeV3SwapCallback(int256, int256 fee, bytes calldata) public {
        console.log("   Let's make a flashloan and get some usdc, which would be used to do the liquidation");
        emit log_named_decimal_uint(
            "   [While liquidation],  usdc", usdc.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "   [While liquidation],  weth", weth.balanceOf(address(this)), 18
        );

        usdc.approve(address(aavePoolV3), type(uint256).max);
        aavePoolV3.liquidationCall(address(weth), address(usdc), user, DEBT_ASSET_USDC_AMOUNT, false);
        weth.transfer(address(pancakeV3Pool), DEBT_ASSET_USDC_AMOUNT + uint256(fee));
        console.log("   Let's pay back flashloan");
    }

}