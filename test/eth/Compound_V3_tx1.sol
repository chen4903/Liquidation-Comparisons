//SPDX-License-Identifier: Unlicense
pragma solidity =0.8.19;

import "forge-std/Test.sol";
import "../interface.sol";

// @tx hash: 0x11d6b57f220427c34628c3bafaaed106d8b46f5ba379824c606bbfafecd93255
// Debt Asset: LINK
// Liquidation Asset: USDC

contract LiquidationOperator is Test {

    IERC20 public usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ICompoundV3cToken public compound_usdc_v3 = ICompoundV3cToken(0xc3d688B66703497DAA19211EEdff47f25384cdc3);
    address user = 0xF2f0B05676d1dE3920401Bb9639Ae260fdffC09f;
    IUniswapV3Pool public uniswapV3Pool_UsdcWeth = IUniswapV3Pool(0xE0554a476A092703abdB3Ef35c80e0D76d32939F);
    IUniswapV3Pool public uniswapV3Pool_LinkWeth = IUniswapV3Pool(0xa6Cc3C2531FdaA6Ae1A3CA84c2855806728693e8);
    IWETH weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 link = IERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);
    uint256 count = 0;

    uint256 constant public wethBeginBalance = 8036936676600142848;

    function setUp() public {
        vm.createSelectFork("mainnet", 21218344);
        // check: https://etherscan.io/txs?block=21064866&p=4
        // back run: 0xb301c753d0fcd45e7e72dd665d213d726fc0b4ac36705fb222f28bfab18cf957
        vm.rollFork(bytes32(0x11d6b57f220427c34628c3bafaaed106d8b46f5ba379824c606bbfafecd93255));
        deal(address(weth), address(this), wethBeginBalance); // prepare some money
    }

    function test_liquidation() public {

        usdc.approve(address(compound_usdc_v3), type(uint256).max);

        bool isLiquidatable = compound_usdc_v3.isLiquidatable(user);
        console.log("isLiquidatable:", isLiquidatable);

        emit log_named_decimal_uint(
            "   usdc", usdc.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "   weth", weth.balanceOf(address(this)), 18
        );
        emit log_named_decimal_uint(
            "   link", link.balanceOf(address(this)), 18
        );

        // weth => usdc
        uniswapV3Pool_UsdcWeth.swap(address(this), false, int256(wethBeginBalance), 1461446703485210103287273052203988822378723970341, "");
        console.log("swap: weth => usdc");
        emit log_named_decimal_uint(
            "   usdc", usdc.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "   weth", weth.balanceOf(address(this)), 18
        );
        emit log_named_decimal_uint(
            "   link", link.balanceOf(address(this)), 18
        );
        console.log("start liquidate");

        address[] memory users = new address[](1);
        users[0] = user;
        console.log("   absorb(): set absorber and users");
        compound_usdc_v3.absorb(address(this), users);
        console.log("   buyCollateral(): usdc => link");
        compound_usdc_v3.buyCollateral(address(link), 0, 20286729768, address(this));

        console.log("end liquidate");
        emit log_named_decimal_uint(
            "   usdc", usdc.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "   weth", weth.balanceOf(address(this)), 18
        );
        emit log_named_decimal_uint(
            "   link", link.balanceOf(address(this)), 18
        );

        // link => weth
        uniswapV3Pool_LinkWeth.swap(address(this), true, int256(link.balanceOf(address(this))), 4295128740, "");
        console.log("swap: link => weth");
        emit log_named_decimal_uint(
            "   usdc", usdc.balanceOf(address(this)), 6
        );
        emit log_named_decimal_uint(
            "   weth", weth.balanceOf(address(this)), 18
        );
        emit log_named_decimal_uint(
            "   link", link.balanceOf(address(this)), 18
        );

        isLiquidatable = compound_usdc_v3.isLiquidatable(user);
        console.log("isLiquidatable:", isLiquidatable);
        
        emit log_named_decimal_uint(
            "weth profit", weth.balanceOf(address(this)) - wethBeginBalance, 18
        );
    }

    function uniswapV3SwapCallback(int256, int256, bytes calldata) public {
        if(count == 0) {
            count++;
            weth.transfer(msg.sender, wethBeginBalance);
        } else {
            link.transfer(msg.sender, link.balanceOf(address(this)));
        }
    }
}