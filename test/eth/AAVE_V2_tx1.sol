//SPDX-License-Identifier: Unlicense
pragma solidity =0.8.19;

import "forge-std/Test.sol";
import "../interface.sol";

// @tx hash: 0xac7df37a43fab1b130318bbb761861b8357650db2e2c6493b73d6da3d9581077
// @profit : 43.830663994245593622 ETH

contract LiquidationOperator is IUniswapV2Callee, Test {

    // user The address of the borrower getting liquidated: loan of USDT collateralized with WBTC
    address user_to_be_liquidated = 0x59CE4a2AC5bC3f5F225439B2993b86B42f6d3e9F; 

    // The tokens to interact with
    IERC20 USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IERC20 WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    IWETH WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
     
    ILendingPool lending_pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9); // aave v2
    IUniswapV2Router02 uniswap_router = IUniswapV2Router02(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)); // swap
    IUniswapV2Pair weth_usdt_uniswap = IUniswapV2Pair(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852); // flashloan

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

    // required by the testing script, entry for your liquidation call
    function operate() external {

        (, , , , , uint256 healthFactor) = lending_pool.getUserAccountData(user_to_be_liquidated); 
        require(healthFactor < 1e18, "health factor should below 1 before liquidation");

        // 1744500000000 is not the best, I just change it and try again and again
        uint256 flashloan_for_usdt = 2744500000000; 
        emit log_named_decimal_uint(
            "   Flashloan for USDT(WETH-USDT)", flashloan_for_usdt, 6
        );

        // flashloan and do the liquidation in the uniswapV2Call()
        weth_usdt_uniswap.swap(0, flashloan_for_usdt, address(this), "Go to the uniswapV2Call()");

        uint256 my_wbtc_balance = WBTC.balanceOf(address(this));
        WBTC.approve(address(uniswap_router), type(uint256).max); 
        address[] memory pair = new address[](2); 
        pair[0] = address(WBTC);
        pair[1] = address(WETH);

        console.log("           (swap[uni_v2]: WBTC => WETH to myself)");

        // swap: wbtc => weth
        uniswap_router.swapExactTokensForTokens(my_wbtc_balance, 0, pair, address(this), type(uint64).max);

        my_wbtc_balance = WBTC.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My WBTC balance after swap to withdraw", my_wbtc_balance, 8
        );
        uint256 my_USDT_balance = USDT.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My USDT balance after swap to withdraw", my_USDT_balance, 6
        );
        uint256 my_WETH_balance = WETH.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My WETH balance after swap to withdraw", my_WETH_balance, 18
        );

        // withdraw: weth => eth
        uint256 weth_balance = WETH.balanceOf(address(this));
        WETH.withdraw(weth_balance);
    }

    function uniswapV2Call( // WETH_USDT callback
        address,
        uint256, 
        uint256 amount1, // The amount of USDT I flashloan
        bytes calldata
    ) external override {

        USDT.approve(address(lending_pool), type(uint256).max); // prepare for swap
        (uint112 reserves_weth, uint112 reserves_usdt, ) = IUniswapV2Pair(msg.sender).getReserves();

        // false => get the underlying collateral asset: WBTC, not aWBTC
        // amount1 is the amount we want to liquidate
        lending_pool.liquidationCall(address(WBTC), address(USDT), user_to_be_liquidated, amount1, false);

        console.log("           (use USDT to liquidate, how much to liquidate can get more profit is a critical issue)");

        uint256 my_wbtc_balance = WBTC.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My WBTC balance after liquidation", my_wbtc_balance, 8
        );
        uint256 my_USDT_balance = USDT.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My USDT balance after liquidation", my_USDT_balance, 6
        );
        uint256 my_WETH_balance = WETH.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My WETH balance after liquidation", my_WETH_balance, 18
        );

        WBTC.approve(address(uniswap_router), type(uint256).max);  // prepare for swap
        address[] memory path = new address[](2);
        path[0] = address(WBTC);
        path[1] = address(WETH);
        // amount1 is the amount we flashloan
        // by getAmountIn(), we can caculate the WBTC
        uint256 amount_plus_fee_in_amount0 = getAmountIn(amount1, reserves_weth, reserves_usdt);

        console.log("           (swap[uni_v2]: WBTC => WETH to pair, we can pay back WETH although we flashloan for USDT)");

        // pay back flashloan: borrow USDT, pay WETH
        uniswap_router.swapTokensForExactTokens(amount_plus_fee_in_amount0, type(uint256).max, path, msg.sender, type(uint64).max);

        my_wbtc_balance = WBTC.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My WBTC balance after paying back flashloan", my_wbtc_balance, 8
        );
        my_USDT_balance = USDT.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My USDT balance after paying back flashloan", my_USDT_balance, 6
        );
        my_WETH_balance = WETH.balanceOf(address(this));
        emit log_named_decimal_uint(
            "       My WETH balance after paying back flashloan", my_WETH_balance, 18
        );

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