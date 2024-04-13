//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ISushiSwapRouter02 {
    function WETH() external view returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function factory() external view returns (address);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountsIn(uint256 amountOut, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

}

interface ICurvePool {
    function A() external view returns (uint256 out);

    function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external payable returns (uint256);

    function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external returns (uint256);

    function add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount) external returns (uint256);

    function admin_fee() external view returns (uint256 out);

    function balances(uint256 arg0) external view returns (uint256 out);

    function calc_token_amount(uint256[] memory amounts, bool is_deposit) external view returns (uint256 lp_tokens);

    /// @dev vyper upgrade changed this on us
    function coins(int128 arg0) external view returns (address out);

    /// @dev vyper upgrade changed this on us
    function coins(uint256 arg0) external view returns (address out);

    /// @dev vyper upgrade changed this on us
    function underlying_coins(int128 arg0) external view returns (address out);

    /// @dev vyper upgrade changed this on us
    function underlying_coins(uint256 arg0) external view returns (address out);

    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable;

    // newer pools have this improved version of exchange_underlying
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy, address receiver) external returns (uint256);

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy,
        bool use_eth,
        address receiver
    ) external returns (uint256);

    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function exchange_underlying(address pool, int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function fee() external view returns (uint256 out);

    function future_A() external view returns (uint256 out);

    function future_fee() external view returns (uint256 out);

    function future_admin_fee() external view returns (uint256 out);

    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);

    function get_dy_underlying(int128 i, int128 j, uint256 dx) external view returns (uint256);

    function get_virtual_price() external view returns (uint256 out);

    function remove_liquidity(
        uint256 token_amount,
        uint256[2] memory min_amounts
    ) external returns (uint256[2] memory);

    function remove_liquidity(
        uint256 token_amount,
        uint256[3] memory min_amounts
    ) external returns (uint256[3] memory);

    function remove_liquidity_imbalance(uint256[3] memory amounts, uint256 max_burn_amount) external;

    function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external;
}

interface ISushiSwap_Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function MINIMUM_LIQUIDITY() external view returns (uint256);

    function PERMIT_TYPEHASH() external view returns (bytes32);

    function allowance(address, address) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function decimals() external view returns (uint8);

    function factory() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        );

    function initialize(address _token0, address _token1) external;

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function name() external view returns (string memory);

    function nonces(address) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function skim(address to) external;

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes memory data
    ) external;

    function symbol() external view returns (string memory);

    function sync() external;

    function token0() external view returns (address);

    function token1() external view returns (address);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}


interface IAAVE_V2_aToken {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event BalanceTransfer(
        address indexed from,
        address indexed to,
        uint256 value,
        uint256 index
    );
    event Burn(
        address indexed from,
        address indexed target,
        uint256 value,
        uint256 index
    );
    event Mint(address indexed from, uint256 value, uint256 index);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function ATOKEN_REVISION() external view returns (uint256);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function EIP712_REVISION() external view returns (bytes memory);

    function PERMIT_TYPEHASH() external view returns (bytes32);

    function POOL() external view returns (address);

    function RESERVE_TREASURY_ADDRESS() external view returns (address);

    function UINT_MAX_VALUE() external view returns (uint256);

    function UNDERLYING_ASSET_ADDRESS() external view returns (address);

    function _nonces(address) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address user) external view returns (uint256);

    function burn(
        address user,
        address receiverOfUnderlying,
        uint256 amount,
        uint256 index
    ) external;

    function decimals() external view returns (uint8);

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function getScaledUserBalanceAndSupply(address user)
        external
        view
        returns (uint256, uint256);

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);

    function initialize(
        uint8 underlyingAssetDecimals,
        string memory tokenName,
        string memory tokenSymbol
    ) external;

    function mint(
        address user,
        uint256 amount,
        uint256 index
    ) external returns (bool);

    function mintToTreasury(uint256 amount, uint256 index) external;

    function name() external view returns (string memory);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function scaledBalanceOf(address user) external view returns (uint256);

    function scaledTotalSupply() external view returns (uint256);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transferOnLiquidation(
        address from,
        address to,
        uint256 value
    ) external;

    function transferUnderlyingTo(address target, uint256 amount)
        external
        returns (uint256);
}

interface ILendingPool {
    event Borrow(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        uint256 borrowRateMode,
        uint256 borrowRate,
        uint16 indexed referral
    );
    event Deposit(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        uint16 indexed referral
    );
    event FlashLoan(
        address indexed target,
        address indexed initiator,
        address indexed asset,
        uint256 amount,
        uint256 premium,
        uint16 referralCode
    );
    event LiquidationCall(
        address indexed collateralAsset,
        address indexed debtAsset,
        address indexed user,
        uint256 debtToCover,
        uint256 liquidatedCollateralAmount,
        address liquidator,
        bool receiveAToken
    );
    event Paused();
    event RebalanceStableBorrowRate(
        address indexed reserve,
        address indexed user
    );
    event Repay(
        address indexed reserve,
        address indexed user,
        address indexed repayer,
        uint256 amount
    );
    event ReserveDataUpdated(
        address indexed reserve,
        uint256 liquidityRate,
        uint256 stableBorrowRate,
        uint256 variableBorrowRate,
        uint256 liquidityIndex,
        uint256 variableBorrowIndex
    );
    event ReserveUsedAsCollateralDisabled(
        address indexed reserve,
        address indexed user
    );
    event ReserveUsedAsCollateralEnabled(
        address indexed reserve,
        address indexed user
    );
    event Swap(address indexed reserve, address indexed user, uint256 rateMode);
    event Unpaused();
    event Withdraw(
        address indexed reserve,
        address indexed user,
        address indexed to,
        uint256 amount
    );

    function FLASHLOAN_PREMIUM_TOTAL() external view returns (uint256);

    function LENDINGPOOL_REVISION() external view returns (uint256);

    function MAX_NUMBER_RESERVES() external view returns (uint256);

    function MAX_STABLE_RATE_BORROW_SIZE_PERCENT()
        external
        view
        returns (uint256);

    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external;

    function deposit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;

    function finalizeTransfer(
        address asset,
        address from,
        address to,
        uint256 amount,
        uint256 balanceFromBefore,
        uint256 balanceToBefore
    ) external;

    function flashLoan(
        address receiverAddress,
        address[] memory assets,
        uint256[] memory amounts,
        uint256[] memory modes,
        address onBehalfOf,
        bytes memory params,
        uint16 referralCode
    ) external;

    function getAddressesProvider() external view returns (address);

    function getConfiguration(address asset)
        external
        view
        returns (DataTypes.ReserveConfigurationMap memory);

    function getReserveData(address asset)
        external
        view
        returns (DataTypes.ReserveData memory);

    function getReserveNormalizedIncome(address asset)
        external
        view
        returns (uint256);

    function getReserveNormalizedVariableDebt(address asset)
        external
        view
        returns (uint256);

    function getReservesList() external view returns (address[] memory);

    function getUserAccountData(address user)
        external
        view
        returns (
            uint256 totalCollateralETH,
            uint256 totalDebtETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        );

    function getUserConfiguration(address user)
        external
        view
        returns (DataTypes.UserConfigurationMap memory);

    function initReserve(
        address asset,
        address aTokenAddress,
        address stableDebtAddress,
        address variableDebtAddress,
        address interestRateStrategyAddress
    ) external;

    function initialize(address provider) external;

    function liquidationCall(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover,
        bool receiveAToken
    ) external;

    function paused() external view returns (bool);

    function rebalanceStableBorrowRate(address asset, address user) external;

    function repay(
        address asset,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external returns (uint256);

    function setConfiguration(address asset, uint256 configuration) external;

    function setPause(bool val) external;

    function setReserveInterestRateStrategyAddress(
        address asset,
        address rateStrategyAddress
    ) external;

    function setUserUseReserveAsCollateral(address asset, bool useAsCollateral)
        external;

    function swapBorrowRateMode(address asset, uint256 rateMode) external;

    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns (uint256);
}

interface DataTypes {
    struct ReserveConfigurationMap {
        uint256 data;
    }

    struct ReserveData {
        ReserveConfigurationMap configuration;
        uint128 liquidityIndex;
        uint128 variableBorrowIndex;
        uint128 currentLiquidityRate;
        uint128 currentVariableBorrowRate;
        uint128 currentStableBorrowRate;
        uint40 lastUpdateTimestamp;
        address aTokenAddress;
        address stableDebtTokenAddress;
        address variableDebtTokenAddress;
        address interestRateStrategyAddress;
        uint8 id;
    }

    struct UserConfigurationMap {
        uint256 data;
    }
}

interface IUniswapV2Router02 {
    function WETH() external view returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function factory() external view returns (address);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountsIn(uint256 amountOut, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    receive() external payable;
}

interface IERC20 {
    // Returns the account balance of another account with address _owner.
    function balanceOf(address owner) external view returns (uint256);

    /**
     * Allows _spender to withdraw from your account multiple times, up to the _value amount.
     * If this function is called again it overwrites the current allowance with _value.
     * Lets msg.sender set their allowance for a spender.
     **/
    function approve(address spender, uint256 value) external; // return type is deleted to be compatible with USDT
    /**
     * Transfers _value amount of debtAsset_USDTs to address _to, and MUST fire the Transfer event.
     * The function SHOULD throw if the message caller’s account balance does not have enough debtAsset_USDTs to spend.
     * Lets msg.sender send pool debtAsset_USDTs to an address.
     **/
    function transfer(address to, uint256 value) external returns (bool);
    
    // Added by Albert
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface IWETH is IERC20 {
    // Convert the wrapped token back to Ether.
    function withdraw(uint256) external;
}

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function MINIMUM_LIQUIDITY() external view returns (uint256);

    function PERMIT_TYPEHASH() external view returns (bytes32);

    function allowance(address, address) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function decimals() external view returns (uint8);

    function factory() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        );

    function initialize(address _token0, address _token1) external;

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function name() external view returns (string memory);

    function nonces(address) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function skim(address to) external;

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes memory data
    ) external;

    function symbol() external view returns (string memory);

    function sync() external;

    function token0() external view returns (address);

    function token1() external view returns (address);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface ICompound_v2_cToken {
    function name() external view returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool);

    function repayBorrow(uint256 repayAmount) external returns (uint256);

    function reserveFactorMantissa() external view returns (uint256);

    function borrowBalanceCurrent(address account) external returns (uint256);

    function totalSupply() external view returns (uint256);

    function exchangeRateStored() external view returns (uint256);

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external returns (bool);

    function repayBorrowBehalf(address borrower, uint256 repayAmount)
        external
        returns (uint256);

    function pendingAdmin() external view returns (address);

    function decimals() external view returns (uint256);

    function balanceOfUnderlying(address owner) external returns (uint256);

    function getCash() external view returns (uint256);

    function _setComptroller(address newComptroller) external returns (uint256);

    function totalBorrows() external view returns (uint256);

    function comptroller() external view returns (address);

    function _reduceReserves(uint256 reduceAmount) external returns (uint256);

    function initialExchangeRateMantissa() external view returns (uint256);

    function accrualBlockNumber() external view returns (uint256);

    function underlying() external view returns (address);

    function balanceOf(address owner) external view returns (uint256);

    function totalBorrowsCurrent() external returns (uint256);

    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    function totalReserves() external view returns (uint256);

    function symbol() external view returns (string memory);

    function borrowBalanceStored(address account)
        external
        view
        returns (uint256);

    function mint(uint256 mintAmount) external returns (uint256);

    function accrueInterest() external returns (uint256);

    function transfer(address dst, uint256 amount) external returns (bool);

    function borrowIndex() external view returns (uint256);

    function supplyRatePerBlock() external view returns (uint256);

    function seize(
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function _setPendingAdmin(address newPendingAdmin)
        external
        returns (uint256);

    function exchangeRateCurrent() external returns (uint256);

    function getAccountSnapshot(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        );

    function borrow(uint256 borrowAmount) external returns (uint256);

    function redeem(uint256 redeemTokens) external returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function _acceptAdmin() external returns (uint256);

    function _setInterestRateModel(address newInterestRateModel)
        external
        returns (uint256);

    function interestRateModel() external view returns (address);

    function liquidateBorrow(
        address borrower,
        uint256 repayAmount,
        address cTokenCollateral
    ) external returns (uint256);

    function admin() external view returns (address);

    function borrowRatePerBlock() external view returns (uint256);

    function _setReserveFactor(uint256 newReserveFactorMantissa)
        external
        returns (uint256);

    function isCToken() external view returns (bool);

    event AccrueInterest(
        uint256 interestAccumulated,
        uint256 borrowIndex,
        uint256 totalBorrows
    );
    event Mint(address minter, uint256 mintAmount, uint256 mintTokens);
    event Redeem(address redeemer, uint256 redeemAmount, uint256 redeemTokens);
    event Borrow(
        address borrower,
        uint256 borrowAmount,
        uint256 accountBorrows,
        uint256 totalBorrows
    );
    event RepayBorrow(
        address payer,
        address borrower,
        uint256 repayAmount,
        uint256 accountBorrows,
        uint256 totalBorrows
    );
    event LiquidateBorrow(
        address liquidator,
        address borrower,
        uint256 repayAmount,
        address cTokenCollateral,
        uint256 seizeTokens
    );
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
    event NewAdmin(address oldAdmin, address newAdmin);
    event NewComptroller(address oldComptroller, address newComptroller);
    event NewMarketInterestRateModel(
        address oldInterestRateModel,
        address newInterestRateModel
    );
    event NewReserveFactor(
        uint256 oldReserveFactorMantissa,
        uint256 newReserveFactorMantissa
    );
    event ReservesReduced(
        address admin,
        uint256 reduceAmount,
        uint256 newTotalReserves
    );
    event Failure(uint256 error, uint256 info, uint256 detail);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
}

interface ICompound_v2_comptroller {
    event ActionPaused(string action, bool pauseState);
    event ActionPaused(address cToken, string action, bool pauseState);
    event CompBorrowSpeedUpdated(address indexed cToken, uint256 newSpeed);
    event CompGranted(address recipient, uint256 amount);
    event CompSupplySpeedUpdated(address indexed cToken, uint256 newSpeed);
    event ContributorCompSpeedUpdated(
        address indexed contributor,
        uint256 newSpeed
    );
    event DistributedBorrowerComp(
        address indexed cToken,
        address indexed borrower,
        uint256 compDelta,
        uint256 compBorrowIndex
    );
    event DistributedSupplierComp(
        address indexed cToken,
        address indexed supplier,
        uint256 compDelta,
        uint256 compSupplyIndex
    );
    event Failure(uint256 error, uint256 info, uint256 detail);
    event MarketEntered(address cToken, address account);
    event MarketExited(address cToken, address account);
    event MarketListed(address cToken);
    event NewBorrowCap(address indexed cToken, uint256 newBorrowCap);
    event NewBorrowCapGuardian(
        address oldBorrowCapGuardian,
        address newBorrowCapGuardian
    );
    event NewCloseFactor(
        uint256 oldCloseFactorMantissa,
        uint256 newCloseFactorMantissa
    );
    event NewCollateralFactor(
        address cToken,
        uint256 oldCollateralFactorMantissa,
        uint256 newCollateralFactorMantissa
    );
    event NewLiquidationIncentive(
        uint256 oldLiquidationIncentiveMantissa,
        uint256 newLiquidationIncentiveMantissa
    );
    event NewPauseGuardian(address oldPauseGuardian, address newPauseGuardian);
    event NewPriceOracle(address oldPriceOracle, address newPriceOracle);

    function _become(address unitroller) external;

    function _borrowGuardianPaused() external view returns (bool);

    function _grantComp(address recipient, uint256 amount) external;

    function _mintGuardianPaused() external view returns (bool);

    function _setBorrowCapGuardian(address newBorrowCapGuardian) external;

    function _setBorrowPaused(address cToken, bool state)
        external
        returns (bool);

    function _setCloseFactor(uint256 newCloseFactorMantissa)
        external
        returns (uint256);

    function _setCollateralFactor(
        address cToken,
        uint256 newCollateralFactorMantissa
    ) external returns (uint256);

    function _setCompSpeeds(
        address[] memory cTokens,
        uint256[] memory supplySpeeds,
        uint256[] memory borrowSpeeds
    ) external;

    function _setContributorCompSpeed(address contributor, uint256 compSpeed)
        external;

    function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa)
        external
        returns (uint256);

    function _setMarketBorrowCaps(
        address[] memory cTokens,
        uint256[] memory newBorrowCaps
    ) external;

    function _setMintPaused(address cToken, bool state) external returns (bool);

    function _setPauseGuardian(address newPauseGuardian)
        external
        returns (uint256);

    function _setPriceOracle(address newOracle) external returns (uint256);

    function _setSeizePaused(bool state) external returns (bool);

    function _setTransferPaused(bool state) external returns (bool);

    function _supportMarket(address cToken) external returns (uint256);

    function accountAssets(address, uint256) external view returns (address);

    function admin() external view returns (address);

    function allMarkets(uint256) external view returns (address);

    function borrowAllowed(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external returns (uint256);

    function borrowCapGuardian() external view returns (address);

    function borrowCaps(address) external view returns (uint256);

    function borrowGuardianPaused(address) external view returns (bool);

    function borrowVerify(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external;

    function checkMembership(address account, address cToken)
        external
        view
        returns (bool);

    function claimComp(address holder, address[] memory cTokens) external;

    function claimComp(
        address[] memory holders,
        address[] memory cTokens,
        bool borrowers,
        bool suppliers
    ) external;

    function claimComp(address holder) external;

    function closeFactorMantissa() external view returns (uint256);

    function compAccrued(address) external view returns (uint256);

    function compBorrowSpeeds(address) external view returns (uint256);

    function compBorrowState(address)
        external
        view
        returns (uint224 index, uint32 block);

    function compBorrowerIndex(address, address)
        external
        view
        returns (uint256);

    function compContributorSpeeds(address) external view returns (uint256);

    function compInitialIndex() external view returns (uint224);

    function compRate() external view returns (uint256);

    function compSpeeds(address) external view returns (uint256);

    function compSupplierIndex(address, address)
        external
        view
        returns (uint256);

    function compSupplySpeeds(address) external view returns (uint256);

    function compSupplyState(address)
        external
        view
        returns (uint224 index, uint32 block);

    function comptrollerImplementation() external view returns (address);

    function enterMarkets(address[] memory cTokens)
        external
        returns (uint256[] memory);

    function exitMarket(address cTokenAddress) external returns (uint256);

    function getAccountLiquidity(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function getAllMarkets() external view returns (address[] memory);

    function getAssetsIn(address account)
        external
        view
        returns (address[] memory);

    function getBlockNumber() external view returns (uint256);

    function getCompAddress() external view returns (address);

    function getHypotheticalAccountLiquidity(
        address account,
        address cTokenModify,
        uint256 redeemTokens,
        uint256 borrowAmount
    )
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function isComptroller() external view returns (bool);

    function isDeprecated(address cToken) external view returns (bool);

    function lastContributorBlock(address) external view returns (uint256);

    function liquidateBorrowAllowed(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function liquidateBorrowVerify(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 actualRepayAmount,
        uint256 seizeTokens
    ) external;

    function liquidateCalculateSeizeTokens(
        address cTokenBorrowed,
        address cTokenCollateral,
        uint256 actualRepayAmount
    ) external view returns (uint256, uint256);

    function liquidationIncentiveMantissa() external view returns (uint256);

    function markets(address)
        external
        view
        returns (
            bool isListed,
            uint256 collateralFactorMantissa,
            bool isComped
        );

    function maxAssets() external view returns (uint256);

    function mintAllowed(
        address cToken,
        address minter,
        uint256 mintAmount
    ) external returns (uint256);

    function mintGuardianPaused(address) external view returns (bool);

    function mintVerify(
        address cToken,
        address minter,
        uint256 actualMintAmount,
        uint256 mintTokens
    ) external;

    function oracle() external view returns (address);

    function pauseGuardian() external view returns (address);

    function pendingAdmin() external view returns (address);

    function pendingComptrollerImplementation() external view returns (address);

    function redeemAllowed(
        address cToken,
        address redeemer,
        uint256 redeemTokens
    ) external returns (uint256);

    function redeemVerify(
        address cToken,
        address redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    ) external;

    function repayBorrowAllowed(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function repayBorrowVerify(
        address cToken,
        address payer,
        address borrower,
        uint256 actualRepayAmount,
        uint256 borrowerIndex
    ) external;

    function seizeAllowed(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function seizeGuardianPaused() external view returns (bool);

    function seizeVerify(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external;

    function transferAllowed(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external returns (uint256);

    function transferGuardianPaused() external view returns (bool);

    function transferVerify(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external;

    function updateContributorRewards(address contributor) external;
}