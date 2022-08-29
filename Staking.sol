// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, 'Address: insufficient balance');

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, 'Address: low-level call failed');
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'Address: insufficient balance for call');
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), 'Address: call to non-contract');

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, 'SafeMath: addition overflow');

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, 'SafeMath: subtraction overflow');
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, 'SafeMath: multiplication overflow');

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, 'SafeMath: division by zero');
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, 'SafeMath: modulo by zero');
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IBEP20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            'SafeBEP20: approve from non-zero to non-zero allowance'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            'SafeBEP20: decreased allowance below zero'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
        }
    }
}

contract StakingPlatform is Ownable {

    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    struct Staker {
        // 0 : 1 month, 1 : 3 month, 2 : 6 month
        uint256 _mode;
        // Moment staker starts staking
        uint256 _stakeStarttime;
        // Moment staker updates staking
        uint256 _stakeUpdatetime;
        // Total amount of staked token of a staker
        uint256 _stakedAmount;
        // Amount of reward of staker
        uint256 _rewardAmount;
        // flag indicating staker staked
        bool _isStaked;
    }

    // Array of address of stakers : for : to get staker list easily
    uint256 public _stakerCount;
    // Map of details of stakers
    mapping(address => Staker) private _stakerInfor;

    // Total amount of staked token
    uint256 public _totalStaked;
    // Token launched
    IBEP20 public _token;

    // Event for staker's staking
    event Staked(address staker, uint256 amount);
    // Event for staker's withdraw
    event Withdraw(address staker, uint256 amount);
    // Event for staker's harvest
    event Harvest(address staker, uint256 amount);
    // Event for bountyWallet address set
    event BountyAddressSet(address bountyWallet);

    // % of unstake fee
    mapping(uint256 => mapping(bool => uint256)) public _unstakeFee;
    // % of reward fee
    mapping(uint256 => uint256) public _rewardRate;
    // % of harvest fee
    uint256 private _harvestRate;

    // bounty wallet address
    address _bountyWallet;

    constructor(address token, address bountyWallet) {
        init();
        _token = IBEP20(token);
        _bountyWallet = bountyWallet;
    }

    function init() private {
        // set initial reward fee rate
        _rewardRate[0] = 100;
        _rewardRate[1] = 200;
        _rewardRate[2] = 300;
        // set initial unstake fee rate
        _unstakeFee[0][false] = 1000;
        _unstakeFee[0][true] = 500;
        _unstakeFee[1][false] = 2000;
        _unstakeFee[1][true] = 1000;
        _unstakeFee[2][false] = 3000;
        _unstakeFee[2][true] = 1500;
        // set initial harvest fee rate
        _harvestRate = 100;
    }

    function setBountyWalletAddress(address bountyWallet) external onlyOwner {
        _bountyWallet = bountyWallet;
        emit BountyAddressSet(bountyWallet);
    }

    function startStaking(uint256 amount, uint256 mode) external {
        require(amount > 0, "Amount should be greater than 0");
        require(_token.balanceOf(msg.sender) > amount, "Insufficient");
        require(mode >= 0 && mode <= 2, "Invalid mode");

        // check the stake flag and mode. If staker tries to stake in more than 2 modes, deny it.
        if (_stakerInfor[msg.sender]._isStaked) {
            require(_stakerInfor[msg.sender]._mode == mode, "Can't stake in more than 2 modes.");
        } else {
            _stakerInfor[msg.sender]._stakeStarttime = block.timestamp;
            _stakerInfor[msg.sender]._isStaked = true;
            _stakerInfor[msg.sender]._mode = mode;
            _stakerCount = _stakerCount.add(1);
        }

        stake(amount);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Amount should be greater than 0");
        require(_token.balanceOf(msg.sender) > amount, "Insufficient!");
        require(_stakerInfor[msg.sender]._isStaked, "Error");

        updateReward();

        _token.safeTransferFrom(msg.sender, address(this), amount);
        _stakerInfor[msg.sender]._stakedAmount = _stakerInfor[msg.sender]._stakedAmount.add(amount);
        _totalStaked = _totalStaked.add(amount);

        emit Staked(msg.sender, amount);
    }

    function updateReward() private {
        uint256 stakerStakedAmount = _stakerInfor[msg.sender]._stakedAmount;

        uint256 newReward = stakerStakedAmount.mul(block.timestamp.sub(_stakerInfor[msg.sender]._stakeUpdatetime)).mul(_rewardRate[_stakerInfor[msg.sender]._mode]).div(1 days).div(1e4);
        _stakerInfor[msg.sender]._rewardAmount = _stakerInfor[msg.sender]._rewardAmount.add(newReward);
        _stakerInfor[msg.sender]._stakeUpdatetime = block.timestamp;
    }

    function getNumberofStakers() public view returns (uint256) {
        return _stakerCount;
    }

    function getStakerMode(address addr) public view returns (uint256) {
        require(isStartStaking(addr) == true, "Not a staker");
        return _stakerInfor[addr]._mode;
    }

    function isStartStaking(address addr) public view returns (bool) {
        return _stakerInfor[addr]._isStaked;
    }

    function getStakedAmount(address addr) public view returns (uint256) {
        return _stakerInfor[addr]._stakedAmount;
    }

    function getLockPeriod(address addr) private view returns (uint256) {
        require(isStartStaking(addr), "Not a staker");

        uint256 lockPeriod = 0;
        if ( _stakerInfor[msg.sender]._mode == 0 ) { lockPeriod =  30 days; }
        else if ( _stakerInfor[msg.sender]._mode == 1 ) { lockPeriod =  90 days; }
        else if ( _stakerInfor[msg.sender]._mode == 2 ) { lockPeriod =  180 days; }
        return lockPeriod;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount should be greater than 0");
        require(amount <= _stakerInfor[msg.sender]._stakedAmount, "Invalid amount");

        updateReward();
        uint256 amountTobeWithdrawn = amount >= _token.balanceOf(address(this)) ? _token.balanceOf(address(this)) : amount;
        uint256 during = block.timestamp.sub(_stakerInfor[msg.sender]._stakeStarttime);
        uint256 fee = 0;

        uint256 lockPeriod = getLockPeriod(msg.sender);
        if (during < lockPeriod) {
            // set withdraw fee if staker tries to withdraw token before locked period finishes
            fee = _unstakeFee[_stakerInfor[msg.sender]._mode][false];
        } else {
            fee = _unstakeFee[_stakerInfor[msg.sender]._mode][true];
        }
        _stakerInfor[msg.sender]._stakedAmount = _stakerInfor[msg.sender]._stakedAmount.sub(amountTobeWithdrawn);
        _totalStaked = _totalStaked.sub(amountTobeWithdrawn);
        if (_stakerInfor[msg.sender]._stakedAmount == 0) {
            _stakerInfor[msg.sender]._isStaked = false;
            // TODO: Remove msg.sender from _stakerAddress
            _stakerCount = _stakerCount.sub(1);
        }

        uint256 amountReflectFee = amountTobeWithdrawn.sub(amountTobeWithdrawn.mul(fee).div(1e4));

        _token.safeTransfer(msg.sender, amountReflectFee);
        // _token.safeTransfer(owner(), amountTobeWithdrawn.sub(amountReflectFee));
        _token.safeTransfer(_bountyWallet, amountTobeWithdrawn.sub(amountReflectFee));

        emit Withdraw(msg.sender, amountTobeWithdrawn);
    }

    function setUnstakeFeeRate(uint256 withdrawFee, uint256 mode, bool isLocked) external onlyOwner {
        require(withdrawFee >= 0, "Invalid Unstaking Fee Rate");

        _unstakeFee[mode][isLocked] = withdrawFee;
    }

    function setRewardRate(uint256 rewardRate, uint256 mode) external onlyOwner {
        require(rewardRate > 0, "Invalid Reward Fee Rate");

        _rewardRate[mode] = rewardRate;
    }

    function setHarvestRate(uint256 harvestRate) external onlyOwner {
        require(harvestRate > 0, "Invalid Harvest Fee Rate");

        _harvestRate = harvestRate;
    }

    function harvest() public {
        updateReward();

        uint256 curReward = _stakerInfor[msg.sender]._rewardAmount;
        if (curReward >= _token.balanceOf(address(this))) {
            curReward = _token.balanceOf(address(this));
        }

        uint256 rewardToClaim = curReward.sub(curReward.mul(_harvestRate).div(1e4));

        require(rewardToClaim > 0, "Nothing to claim");
        if (rewardToClaim > _token.balanceOf(address(this))) {
            rewardToClaim = _token.balanceOf(address(this));
        }
        _token.safeTransfer(msg.sender, rewardToClaim);
        _token.safeTransfer(owner(), curReward.sub(rewardToClaim));
        _stakerInfor[msg.sender]._rewardAmount = 0;

        emit Harvest(msg.sender, curReward);
    }
}