# Compound V2 Liquidation

Compound V2的清算比AAVE简洁很多，它提供了非常方便的[接口](https://docs.compound.finance/v2/comptroller/)供我们清算。

它提供了这个函数：

```solidity
function getAccountLiquidity(address account) view returns (uint, uint, uint)
```

> `account`: The account whose liquidity shall be calculated.
>
> `RETURN`: Tuple of values (error, liquidity, shortfall). The error shall be 0 on success, otherwise an [error code](https://docs.compound.finance/v2/comptroller#error-codes). A non-zero liquidity value indicates the account has available [account liquidity](https://docs.compound.finance/v2/comptroller#account-liquidity). A non-zero shortfall value indicates the account is currently below his/her collateral requirement and is subject to liquidation. At most one of liquidity or shortfall shall be non-zero.

- 输入：需要清算的账户
- 输出
  - 清算成功返回0，否则是错误代码
  - 非零的流动性值表示账户有可用的账户流动性
  - 非零的缺口值表示账户当前低于其抵押要求，并可能面临清算。流动性和缺口值最多只有一个为非零。

然后我们只需要监听这个接口的返回值，进行清算就好了。下面是我们清算之后的输出：

```
  [Before] liquidity: 0.000000000000000000
  [Before] shortfall: 26.392206940915889741
  [Before] my cETH: 0.00000000
  [After] liquidity: 332.950243140081219857
  [After] shortfall: 0.000000000000000000
  [After] my cETH: 88730.60279429
```

我们将缺口shortfall完全清算了。使用218213个USDC获得了88730个ETH

测试：`forge test --match-path test/eth/Compound_V2_tx1.sol -vvv`
