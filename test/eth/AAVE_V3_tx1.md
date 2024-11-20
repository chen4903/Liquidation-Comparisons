# AAVE V3 Liquidation

我们这次模拟清算了这笔[交易](https://etherscan.io/tx/0x35240526c70a5bcfe2d7fd5bc5ba668ca3a490c4a135650fb892e70f1f0a0f1d)。使用USDC清算，得到WETH。不算gas的情况下，WETH的利润是：0.085264572859541215WETH。

如今的清算，都是需要进行后跑，在债务情况更新之后，马上跟上清算的交易。比如在区块[21218344](https://etherscan.io/txs?block=21218344&p=4)，一笔交易[0x51b477943b161e0ee0949502d3431e6f47861f0985fc7690d404e4063ae990d8](https://etherscan.io/tx/0x51b477943b161e0ee0949502d3431e6f47861f0985fc7690d404e4063ae990d8)调用了forward函数更新状态，然后此清算的交易紧随其后。

你可以发现其他的清算如出一辙：[21228762](https://etherscan.io/txs?block=21228762&p=4)，[21203687](https://etherscan.io/txs?block=21203687&p=2)，[21207783](https://etherscan.io/txs?block=21207783&p=6)，[21194992](https://etherscan.io/txs?block=21194992&p=5)等等。

这是输出的清算日志：

```
  [Before liquidation], usdc: 0.000000
  [Before liquidation], weth: 0.000000000000000000
  [Before liquidation],  healthFactor: 0.998328069365901610
     Let's make a flashloan and get some usdc, which would be used to do the liquidation
     [While liquidation],  usdc: 5887.364178
     [While liquidation],  weth: 0.000000000000000000
  [After liquidation],  usdc: 0.000000
  [After liquidation],  weth: 0.085264572859541215
  [After liquidation],  healthFactor: 1.125150230742895565
```
测试指令：`forge test --match-path test/eth/AAVE_V3_tx1.sol -vvv --evm-version shanghai`



















