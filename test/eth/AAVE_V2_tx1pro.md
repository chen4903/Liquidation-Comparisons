测试：`forge test --match-path test/eth/AAVE_V2_tx1pro.sol -vvv`

这一次的清算比tx1更多，获得了个85.048539834763696741ETH。

主要是采取了不同的策略：

- 从sushi借入USDC，然后到curve将USDC换成USDT，因为清算是用USDT
- 使用sushi的[WBTC-WETH]来swap，因为K值更大，使得滑点更低。如下计算是在swap之前，我们发现sushiswap的K值是uniswap的五倍，但是价格差距并不是特别大，使用sushiswap能得到更多的产出，因此我们获利更多

```
uniswap_pool_wbtcweth_WBTC_price = 38844042475154482370337 / 229369102880
sushiswap_pool_wtbcweth_WBTC_price = 88902650478574486113986 / 525397180491
price_cap = uniswap_pool_wbtcweth_WBTC_price - sushiswap_pool_wtbcweth_WBTC_price
K_in_uniswap_wbtcweth=38844042475154482370337*229369102880
K_in_sushiswap_wbtcweth=88902650478574486113986*525397180491
times=K_in_sushiswap_wbtcweth/K_in_uniswap_wbtcweth # 5.2425563891353235
print("uniswap_pool_wbtcweth_WBTC_price", uniswap_pool_wbtcweth_WBTC_price)
print("sushiswap_pool_wtbcweth_WBTC_price", sushiswap_pool_wtbcweth_WBTC_price)
print("sushi K is ", times, "time to uniswap K")
```

下面是整个流程：

```
Before totalCollateralETH: 10630.629178806013179408
  Before totalDebtETH: 8093.660042623032904515
  Before availableBorrowsETH: 0.000000000000000000
  Before currentLiquidationThreshold: 0.7561
  Before ltv: 0.7082
  Before healthFactor: 0.993100609584077736

     Flashloan for USDC(USDC-WETH): 2919549.181195
             (Use USDC to liquidate, how much to liquidate can get more profit is a critical issue)
         My WBTC balance: 0.00000000
         My USDT balance: 0.000000
         My USDC balance: 2919549.181195
         My WETH balance: 0.000000000000000000
             (Swap[cureve, DAI_USDC_USDT]: USDC => USDT)
         My WBTC balance: 0.00000000
         My USDT balance: 2916358.033172
         My USDC balance: 0.000000
         My WETH balance: 0.000000000000000000
             (After liquidation)
         My WBTC balance: 94.27272961
         My USDT balance: 0.000000
         My USDC balance: 0.000000
         My WETH balance: 0.000000000000000000
  test reserves_WBTC: 525397180491
  test reserves_WETH: 88902650478574486113986
             (Swap[sushi_v2]: WBTC => WETH. Pay back flashloan + fee. We borrow USDC but pay back WETH)
         My WBTC balance: 5.21848953
         My USDT balance: 0.000000
         My USDC balance: 0.000000
         My WETH balance: 0.000000000000000000
             (Swap[sushi_v2]: WBTC => WETH. We want WETH)
         My WBTC balance: 0.00000000
         My USDT balance: 0.000000
         My USDC balance: 0.000000
         My WETH balance: 85.048539834763696741

     Profit ETH: 85.048539834763696741

  After totalCollateralETH: 9062.096632528174258397
  After totalDebtETH: 6667.721364093260419515
  After availableBorrowsETH: 0.000000000000000000
  After currentLiquidationThreshold: 0.7572
  After ltv: 0.7096
  After healthFactor: 1.029110125552384781
```