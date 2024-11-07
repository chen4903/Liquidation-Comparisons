# Liquidation-Comparisons

## 简介

我们使用foundry对各个借贷协议的清算做实战演示，并且以更高的获利为目标，并且尽可能地讲清楚其中的策略

## 各大协议

| 协议        | 清算函数          |
| ----------- | ----------------- |
| AAVE_V2     | liquidationCall() |
| Compound_V2 | liquidateBorrow() |
| ...         | ...               |

## 影响因素

如何使得获利最大呢？影响的因素大致有以下几点：

- 健康值：并不是越接近1获利就越大
- gas费用：如果获利无法覆盖gas费用，则清算亏本
- 清算数量：每个协议可清算的数量不同，AAVE是最多清算50%，我们应该清算多少才是合理的呢？
- 清算奖励：应该是获得underlying token还是aToken呢？
- swap滑点：
  - 将清算获得的代币转换为我们想要的代币
  - 选择最佳的swap路径，使得滑点最低
- 用户债务规模
  - 价格：得到了清算得到的代币之后，需要查询哪个池子的价格最高
  - 数量：清算得到的代币数量、池子的深度，直接影响了swap得到的产出
- 闪电贷借款（如果是使用闪电贷来清算）：
  - 手续费
  - 可借款的数量

## 数学原理

> 假设均以WETH计价，所有swap最终都转换为WETH

我们定义：

- a：闪电贷借款数量
- b：闪电贷手续费
- c：gas费用
- d：清算奖励经过swap之后得到的WETH数目
- P：最终获利

因此可以写成：

```
S = P - d - b - c，其中 f(a) = d
```

a会间接的影响d，a代表你的在闪电贷赋予下的清算能力。你的清算策略和市场情况直接影响获利，受到上述7个因素混合影响，因此这其中的逻辑不会简单明了。下面让我们来进一步计算清算d：

> TODO
