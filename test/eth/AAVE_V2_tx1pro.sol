//SPDX-License-Identifier: Unlicense
pragma solidity =0.8.19;

import "forge-std/Test.sol";
import "../interface.sol";

// @tx hash: 0xac7df37a43fab1b130318bbb761861b8357650db2e2c6493b73d6da3d9581077
// @Profit : 85.048539834763696741 ETH

contract LiquidationOperator is IUniswapV2Callee, Test {

    // user The address of the borrower getting liquidated: loan of USDT collateralized with WBTC
    address public user_to_be_liquidated = 0x59CE4a2AC5bC3f5F225439B2993b86B42f6d3e9F; 

    IERC20 USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IWETH WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IERC20 WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);

    ICurvePool public curve_dai_usdc_usdt_pool = ICurvePool(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7); // swap 
    ILendingPool public lending_pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9); // aave v2
    ISushiSwap_Pair public usdc_weth_pair = ISushiSwap_Pair(0x397FF1542f962076d0BFE58eA045FfA2d347ACa0); // flashloan
    ISushiSwapRouter02 public sushiswapRouter02 = ISushiSwapRouter02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); // swap 

    function setUp() public {
        // hash in eth: 0xac7df37a43fab1b130318bbb761861b8357650db2e2c6493b73d6da3d9581077
        vm.createSelectFork("mainnet", 12489620 - 1);
    }

    function test_liquidation() public {
        (uint256 totalCollateralETH, uint256 totalDebtETH, uint256 availableBorrowsETH, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor) = lending_pool.getUserAccountData(user_to_be_liquidated);
        console.log();
        emit log_named_decimal_uint(
            "Before totalCollateralETH", totalCollateralETH, 18
        );
        emit log_named_decimal_uint(
            "Before totalDebtETH", totalDebtETH, 18
        );
        emit log_named_decimal_uint(
            "Before availableBorrowsETH", availableBorrowsETH, 18
        );
        emit log_named_decimal_uint(
            "Before currentLiquidationThreshold", currentLiquidationThreshold, 4
        );
        emit log_named_decimal_uint(
            "Before ltv", ltv, 4
        );
        emit log_named_decimal_uint(
            "Before healthFactor", healthFactor, 18
        );

        console.log();

        uint256 beforeLiquidation = address(this).balance;
        this.operate();
        uint256 afterLiquidation = address(this).balance;
        emit log_named_decimal_uint(
            "   Profit ETH", afterLiquidation - beforeLiquidation, 18
        );

        console.log();

        (totalCollateralETH, totalDebtETH, availableBorrowsETH, currentLiquidationThreshold, ltv, healthFactor) = lending_pool.getUserAccountData(user_to_be_liquidated);
        emit log_named_decimal_uint(
            "After totalCollateralETH", totalCollateralETH, 18
        );
        emit log_named_decimal_uint(
            "After totalDebtETH", totalDebtETH, 18
        );
        emit log_named_decimal_uint(
            "After availableBorrowsETH", availableBorrowsETH, 18
        );
        emit log_named_decimal_uint(
            "After currentLiquidationThreshold", currentLiquidationThreshold, 4
        );
        emit log_named_decimal_uint(
            "After ltv", ltv, 4
        );
        emit log_named_decimal_uint(
            "After healthFactor", healthFactor, 18
        );
    }

    function operate() external {
        // flashloan for USDC: 2919549181195
        usdc_weth_pair.swap(2919549181195, 0, address(this), "Go to the call back");
    }

    function uniswapV2Call( // USDC_WETH callback
        address,
        uint256 amount0, // The amount of USDC I flashloan
        uint256, 
        bytes calldata
    ) external override {
        emit log_named_decimal_uint(
            "   Flashloan for USDC(USDC-WETH)", amount0, 6
        );

        console.log("           (Use USDC to liquidate, how much to liquidate can get more profit is a critical issue)");
        emit log_named_decimal_uint(
            "       My WBTC balance", WBTC.balanceOf(address(this)), 8
        );
        emit log_named_decimal_uint(
            "       My USDT balance", USDT.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My USDC balance", USDC.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My WETH balance", WETH.balanceOf(address(this)), 18
        );

        // Swap: USDC => USDT. We use curve, because curve is born for stablecoin swap
        USDC.approve(address(curve_dai_usdc_usdt_pool), type(uint256).max);
        curve_dai_usdc_usdt_pool.exchange(1, 2, amount0, 0);

        console.log("           (Swap[cureve, DAI_USDC_USDT]: USDC => USDT)");
        emit log_named_decimal_uint(
            "       My WBTC balance", WBTC.balanceOf(address(this)), 8
        );
        emit log_named_decimal_uint(
            "       My USDT balance", USDT.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My USDC balance", USDC.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My WETH balance", WETH.balanceOf(address(this)), 18
        );

        // execute the liquidation with USDT
        USDT.approve(address(lending_pool), type(uint256).max);
        uint256 my_usdt_balance = USDT.balanceOf(address(this));
        lending_pool.liquidationCall(address(WBTC), address(USDT), user_to_be_liquidated, my_usdt_balance, false);

        console.log("           (After liquidation)");
        emit log_named_decimal_uint(
            "       My WBTC balance", WBTC.balanceOf(address(this)), 8
        );
        emit log_named_decimal_uint(
            "       My USDT balance", USDT.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My USDC balance", USDC.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My WETH balance", WETH.balanceOf(address(this)), 18
        );

        // Pay back flashloan plus fee
        WBTC.approve(address(sushiswapRouter02), type(uint256).max);  // prepare for swap
        (uint112 reserves_usdc, uint112 reserves_weth, ) = IUniswapV2Pair(msg.sender).getReserves();

        uint256 flashloan_amount_plus_fee_in_amount1 = getAmountIn(amount0, reserves_weth, reserves_usdc); 
        address[] memory path = new address[](2);
        path[0] = address(WBTC);
        path[1] = address(WETH);
        sushiswapRouter02.swapTokensForExactTokens( 
            flashloan_amount_plus_fee_in_amount1, // flashloan amount + fee
            type(uint256).max, // all our WBTC can be swap to WETH
            path, 
            msg.sender, // receiver is pair, so this is why this step is paying back flashloan
            type(uint64).max
        );
        
        console.log("           (Swap[sushi_v2]: WBTC => WETH. Pay back flashloan + fee. We borrow USDC but pay back WETH)");
        emit log_named_decimal_uint(
            "       My WBTC balance", WBTC.balanceOf(address(this)), 8
        );
        emit log_named_decimal_uint(
            "       My USDT balance", USDT.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My USDC balance", USDC.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My WETH balance", WETH.balanceOf(address(this)), 18
        );


        // Swap: WBTC => WETH. Swap all my WBTC to WETH.
        sushiswapRouter02.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            WBTC.balanceOf(address(this)), 
            0, 
            path, 
            address(this), 
            type(uint64).max
        );

        console.log("           (Swap[sushi_v2]: WBTC => WETH. We want WETH)");
        emit log_named_decimal_uint(
            "       My WBTC balance", WBTC.balanceOf(address(this)), 8
        );
        emit log_named_decimal_uint(
            "       My USDT balance", USDT.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My USDC balance", USDC.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "       My WETH balance", WETH.balanceOf(address(this)), 18
        );

        console.log();

        // Swap: WETH => ETH
        uint256 weth_balance = WETH.balanceOf(address(this));
        WETH.withdraw(weth_balance); // That is our profit
    }

    ///////////////////////      view/pure functions     /////////////////////////////

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require(
            reserveIn > 0 && reserveOut > 0,
            "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
        );
        uint256 numerator = reserveIn * amountOut * 1000;
        uint256 denominator = (reserveOut - amountOut) * 997;
        amountIn = (numerator / denominator) + 1;
    }

    receive() external payable {
        // to receive ETH
    }
}