
pragma solidity ^0.8.6;

// SPDX-License-Identifier: Unlicensed

import "./libs/Ownable.sol";
import "./libs/ERC20.sol";

// import "hardhat/console.sol";
import "./libs/TransferHelp.sol";

interface INftMetaSMA {
    function getAnyInviter(address account) external view returns (address);
    function isBlocked(address account) external view returns (bool);
    function refreshNftRewards(uint256 curblock) external returns(bool);
    function autoSetInviter(address account, address newinviter) external returns(bool);
    function getUsrIdoAmount(address account) external view returns(uint256);
}

interface ISnowBPool {
    function getRepayFrontAddress() external view returns(address);
    function newReturnOrder(uint256 _amount,uint256 _value) external returns(bool);
    function newRepayOrder(address _account,uint256 _amount,uint256 _value) external returns(bool);

    function putinRepayPool(uint256 _amount,uint256 _value) external returns(bool);
    function burstFomoPool(bool _istimeburst) external returns(bool);
    function getLastRepayOrderTime() external view returns(uint256); 
    function isInRepayList(address account) external view returns(bool,uint256,uint256);
    function newSingleReturnOrderTransferValue(address _account,uint256 _amount,uint256 _value) external returns(bool);
}

// pragma solidity >=0.5.0;
//lp contract
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);


    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
   
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,

        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;
//dex router contract
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,

        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,

        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;
//dex router contract02

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,

        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

}

contract SNOWBALLNEW is IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;

    bytes public fail;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
	// uint256 private _tTotalMaxFee;
    uint256 private _rTotal;
    uint256 private _tFeeTotal;
    bool private _canSwap;
    bool private _canTransfer;

    address[] private _excluded; //white list

    INftMetaSMA public idoContract;
    ISnowBPool public snowbPoolContract;
    address public uniswapV2Pair;
    IUniswapV2Router02 public routerAddress;

    string private _name;
    string private _symbol;
    uint256 private _decimals;
    
    uint256 private   feeLevels;

    uint256 private devopsRate; 
    
    uint256 private fomoRate;
    uint256 private swapRepayRate;

    uint256 private repayRate;
    uint256 private repayInvitRate;
    uint256 private repayFomoRate;

    uint256 private repayReturnRate;
    uint256 private transferRate;

    uint256 public beginTime;

    address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);
    address public _devopsAddress; 
    
    constructor(address tokenOwner,address _routerAddress, address _devopsaddress, uint256 _devopsRate,uint256 _nftRate, 
        uint256 _fomoRate, uint256 _swapRepayRate, uint256 _repayRate,uint256 _repayInvitRate, uint256 _repayFomoRate, uint256 _feeLevels) {
        _name = "Shib Mutual Aid";
        _symbol = "SMA";
        _decimals = 18;

		// _tTotalMaxFee = _tTotal.div(100).mul(99);
		
        _rTotal = (MAX - (MAX % _tTotal));
        _rOwned[tokenOwner] = _rTotal;
        _isExcludedFromFee[msg.sender] = true; 
        _isExcludedFromFee[tokenOwner] = true; 
        _isExcludedFromFee[address(this)] = true;
        routerAddress = IUniswapV2Router02(_routerAddress);
        _devopsAddress = _devopsaddress;
        
        devopsRate = _devopsRate; //0.5%
        nftRate = _nftRate; //4%
        swapRepayRate = _swapRepayRate; //1.5%
        fomoRate = _fomoRate;   //1.0
        repayRate = _repayRate; //63%
        repayInvitRate = _repayInvitRate;   //32%
        repayFomoRate = _repayFomoRate; //5%

        repayReturnRate = 500; //50%
        transferRate = 300;   //15%

        feeLevels = _feeLevels;

        _canSwap = false;

        _canRepay = false;
        _owner = msg.sender;
        emit Transfer(address(0), tokenOwner, _tTotal);
    }

    function getRepayRate() public view returns (uint256) {
        return repayRate;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {

            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,

    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(amount,"BEP20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function excludeFromFee(address account) public onlyOwner {
        require(account != _owner && account != address(0),"Can't set owner or zero");
        require(!_isExcludedFromFee[account], "Account is already excluded");

  rue;
        _excluded.push(account);
    }

    function includeInFee(address account) public onlyOwner {
        require(account !=_owner && account !=address(0),"Can't set owner or zero");
        require(_isExcludedFromFee[account], "Account is not excluded");

        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _isExcludedFromFee[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function getFeeArry() public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
        return (devopsRate , nftRate, swapRepayRate, fomoRate, 
            repayRate, repayInvitRate, repayFomoRate, repayReturnRate, transferRate, feeLevels);
    }

    function setFeeArry(uint256 _devopsRate,uint256 _nftRate, uint256 _fomoRate, uint256 _swapRepayRate, 
        uint256 _repayRate,uint256 _repayInvitRate, uint256 _repayFomoRate, 
        uint256 _repayReturnRate, uint256 _transferRate, uint256 _feeLevels) public onlyOwner {

        devopsRate = _devopsRate; //0.5%
        nftRate = _nftRate; //4%
        swapRepayRate = _swapRepayRate; //1.5%
        fomoRate = _fomoRate;   //1.5
        repayRate = _repayRate; //63%
        repayInvitRate = _repayInvitRate;   //32%
        repayFomoRate = _repayFomoRate; //5%

        repayReturnRate = _repayReturnRate;
        transferRate = _transferRate;
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function claimTokens() public onlyOwner {
        TransferHelper.safeTransferETH(_owner, address(this).balance);
    }

    
    function claimOtherTokens(IERC20 token,address to, uint256 amount) public onlyOwner {
        require(to != address(this) && to != address(0) && address(token) != address(0), "Error target address");
        uint256 abalance;
        abalance = token.balanceOf(address(this));
        require(amount <= abalance && amount>0, "Insufficient funds");

        TransferHelper.safeTransfer(address(token), to, amount);
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0) && to != address(0), "BEP20: transfer from or to the zero address");
        require(_canTransfer, "Transfer paused!");
        require(!idoContract.isBlocked(from), "Sender is Blocked!");
        if (from != address(snowbPoolContract)){
            require(!idoContract.isBlocked(to), "recipient is Blocked!");
        }
        
        require(amount > 0 && amount<= balanceOf(from), "Sender insufficient funds");
        		
        bool takeFee = true;
		uint256 _value;
        uint256 _idoamount;

        if(from != uniswapV2Pair && to != uniswapV2Pair && from != address(routerAddress)){
            takeFee = false;
        }else{
            if (!_canSwap){
                _value = _getAmountValue(amount);
                _idoamount = idoContract.getUsrIdoAmount(to);  //check nft amount
                
                if (from == _owner || to == _owner ||
                    (_idoamount>0 && _value<=(_idoamount.div(3)) && _value>=(_idoamount.div(4)))){
                }else{
                    require(_canSwap, "Swap paused!");
                }
            }
        }

        if (to == address(routerAddress)){
            if (!_canSwap){
                _value = _getAmountValue(amount);
                _idoamount = idoContract.getUsrIdoAmount(to);
                
                if (from == _owner || from == uniswapV2Pair ||
                    (_idoamount>0 && _value<=(_idoamount.div(3)) && _value>=(_idoamount.div(4)))){
                        
                }else{
                    require(_canSwap, "Swap paused!");
                }

        }
        
        // console.log(from,to,amount,takeFee);
        _tokenTransfer(from, to, amount, takeFee);

    }

    function _getAmountValue(uint256 amount) public view returns(uint256 value){
        uint256 reserve0;
        uint256 reserve1;

        if (amount==0){
            value =0;
            return value;
        }
        
        if (uniswapV2Pair!=address(0)){
            (reserve0,reserve1,) = IUniswapV2Pair(uniswapV2Pair).getReserves();
            if (reserve0>0 && reserve1>0){
                if (IUniswapV2Pair(uniswapV2Pair).token0()==address(this)){
                    value  = IUniswapV2Router02(routerAddress).getAmountOut(amount,reserve0,reserve1);
                }else{
                    value  = IUniswapV2Router02(routerAddress).getAmountOut(amount,reserve1,reserve0);
                }
            }else{
                value = 0;
            }
        }else{
            value = 0;
        }
        
        return value;
    }
    
    function _tokenTransfer(
        address sender,

        bool _isSwap
    ) private {
        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rate = 0;
        uint256 _value;

        // console.log(balanceOf(sender),balanceOf(recipient));

        _value = _getAmountValue(tAmount);
        
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        // console.log(_rOwned[sender],rAmount,currentRate);
        if (_isSwap) {
            if (!_isExcludedFromFee[sender] && !_isExcludedFromFee[recipient]){
                // if (feeLevels>0 && invitRate>0){  //0%
                //     _takeInviterFee(sender, recipient, tAmount, currentRate,false); 
                // }
                
                if (devopsRate>0){  //0.5%
                    _takeTransfer(sender,_devopsAddress,tAmount.mul(devopsRate).div(1000),currentRate);
                }

                if (swapRepayRate>0){ //1.5%
                    _takeTransfer(sender,address(snowbPoolContract),tAmount.mul(swapRepayRate).div(1000),currentRate);
                    snowbPoolContract.putinRepayPool(tAmount.mul(swapRepayRate).div(1000), _value.mul(swapRepayRate).div(1000));
                    snowbPoolContract.newReturnOrder(tAmount.mul(swapRepayRate).div(1000), _value.mul(swapRepayRate).div(1000));
                }

                if (fomoRate>0){    //1%
                    _takeTransfer(sender,address(snowbPoolContract),tAmount.mul(fomoRate).div(1000),currentRate);
                    snowbPoolContract.putinFomoPool(tAmount.mul(fomoRate).div(1000), _value.mul(fomoRate).div(1000));
                }
                
                rate = devopsRate  + swapRepayRate + fomoRate;
            }else{
                rate = 0;
            }

            if (rate>0){
                _rOwned[recipient] = _rOwned[recipient].add(
                    rAmount.mul(1000 - rate).div(1000));
                emit Transfer(sender, recipient, tAmount.mul(1000 - rate).div(1000));
            }else{
                _rOwned[recipient] = _rOwned[recipient].add(rAmount);
                emit Transfer(sender, recipient, tAmount);
            }

                require(address(snowbPoolContract) != address(0) && 
                        address(idoContract) != address(0) && _canRepay, "repay paused");
                    
                address firstaddress = snowbPoolContract.getRepayFrontAddress();
                if (idoContract.getAnyInviter(sender)==address(0) && firstaddress!=_destroyAddress &&
                        firstaddress!=address(0)){
                    idoContract.autoSetInviter(sender, firstaddress);
                }

                if (nftRate>0){
                    _takeTransfer(sender,address(idoContract),tAmount.mul(nftRate).div(1000),currentRate); 
                    idoContract.refreshNftRewards(block.number); //nft refresh rewards
                }

                if (repayRate>0 && address(snowbPoolContract) != address(0)){ 
                    _takeTransfer(sender,address(snowbPoolContract),tAmount.mul(repayRate+repayInvitRate+repayFomoRate).div(1000),currentRate); 
                    snowbPoolContract.newRepayOrder(sender, tAmount, _value);
                    snowbPoolContract.newReturnOrder(tAmount.mul(repayReturnRate).div(1000), _value.div(1000).mul(repayReturnRate));
                }

                if (repayInvitRate>0 && address(snowbPoolContract) != address(0)){
                    // _takeTransfer(sender,address(snowbPoolContract),tAmount.mul(repayInvitRate).div(1000),currentRate); 
                    _takeInviterFee(sender, recipient, tAmount, currentRate); 
                }
                
                if (repayFomoRate>0){
                    // _takeTransfer(sender,address(snowbPoolContract),tAmount.div(1000).mul(repayFomoRate),currentRate);
                    snowbPoolContract.putinFomoPool(tAmount.div(1000).mul(repayFomoRate), _value.div(1000).mul(repayFomoRate));
                }

                rate = repayRate + repayInvitRate + repayFomoRate + nftRate;
                
                if ((1000 - rate)>0){
                    _rOwned[recipient] = _rOwned[recipient].add(
                        rAmount.div(1000).mul(1000 - rate));
                    emit Transfer(sender, recipient, tAmount.div(1000).mul(1000 - rate));
                }
                
            }else{
                if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient] ||
                    (recipient == address(routerAddress) && sender == uniswapV2Pair)) {

                }

                if (rate>0){
                    _takeTransfer(sender,address(snowbPoolContract),tAmount.div(1000).mul(transferRate),currentRate); //to repaypool 30%
                    snowbPoolContract.putinRepayPool(tAmount.div(1000).mul(transferRate), _value.div(1000).mul(transferRate));    //pool process                
                    snowbPoolContract.newReturnOrder(tAmount.div(1000).mul(repayReturnRate), _value.div(1000).mul(repayReturnRate)); //return 50% to first address
                }
                
                if ((1000-rate)>0){
                    _rOwned[recipient] = _rOwned[recipient].add(
                        rAmount.div(1000).mul(1000 - rate));
                    emit Transfer(sender, recipient, tAmount.div(1000).mul(1000 - rate));                
                }
            }
        }

        // console.log(balanceOf(sender),balanceOf(recipient),rate);
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount,
        uint256 currentRate
    ) private {
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[to] = _rOwned[to].add(rAmount);
        emit Transfer(sender, to, tAmount);
    }

    function _takeInviterFee(
        address sender,
        address recipient,

        uint256 currentRate
    ) private {
        address cur;
		address reciver;
        uint256 curTAmount;
        uint256 ttdevopsamount;
        uint256 curBalanceof;
        uint256 payedvalue;
        uint256 ttdevopsreturnamount;

        ttdevopsamount = 0;
        ttdevopsreturnamount = 0;
        if (sender == uniswapV2Pair || sender == address(routerAddress)) {
            cur = recipient;
        } else {
            cur = sender;
        }

        for (uint256 i = 0; i < feeLevels; i++) {
            curTAmount = tAmount.div(1000).mul(repayInvitRate).div(feeLevels);
            payedvalue = 0;

            cur = idoContract.getAnyInviter(cur);

            if (cur == address(0)) {    
                reciver = _devopsAddress;
            }else{
                reciver = cur;
            }
            
            curBalanceof = balanceOf(reciver);
            (,,payedvalue) = snowbPoolContract.isInRepayList(reciver);
            if (_getAmountValue(curBalanceof)>=(15*10**18) && 

                if (curTAmount>0){
                    if (reciver == _devopsAddress){
                        ttdevopsreturnamount = ttdevopsreturnamount.add(curTAmount);
                    }else{
                        snowbPoolContract.newSingleReturnOrderTransferValue(reciver,curTAmount,_getAmountValue(curTAmount));
                    }
                }
            }else{
                ttdevopsamount = ttdevopsamount.add(curTAmount);
            }
        }
        if (ttdevopsreturnamount>0){
            snowbPoolContract.newSingleReturnOrderTransferValue(_devopsAddress,ttdevopsreturnamount,_getAmountValue(ttdevopsreturnamount));
        }

        if (ttdevopsamount>0){
            _rOwned[address(snowbPoolContract)] = _rOwned[address(snowbPoolContract)].sub(ttdevopsamount.mul(currentRate));
            _rOwned[_devopsAddress] = _rOwned[_devopsAddress].add(ttdevopsamount.mul(currentRate));
            emit Transfer(address(snowbPoolContract), _devopsAddress, ttdevopsamount); 
        }            
    }
	
    function changeIDOAddress(address _idoAddress) public onlyOwner {
        require(_idoAddress != address(0) && isContract(_idoAddress),"Error zero IDO address");
        require(_idoAddress != address(idoContract),"Error new IDO address can't be same to old");
        
        idoContract = INftMetaSMA(_idoAddress);
    }

    function changeSnowPoolAddress(address _snowPoolAddress) public onlyOwner {
        require(_snowPoolAddress != address(0) && isContract(_snowPoolAddress),"Error zero Pool address");
        require(_snowPoolAddress != address(snowbPoolContract),"Error new Pool address can't be same to old");
        
        snowbPoolContract = ISnowBPool(_snowPoolAddress);
    }

    function changePairAddress(address _pair) public onlyOwner {
        require(_pair != address(0) && isContract(_pair),"Error zero pair address");
        require(_pair != _owner,"Error pair address can't be owner");
        require(_pair != uniswapV2Pair,"Error new pair address can't be same to old");
        
      
    }

    function changeRouteAddress(address _router) public onlyOwner {
        require(_router != address(0) && isContract(_router),"Error zero router address");
        require(_router != _owner,"Error router address can't be owner");
        require(_router != address(routerAddress),"Error new router address can't be same to old");
        
        routerAddress = IUniswapV2Router02(_router);
    }

    fallback () external {
        fail = msg.data;
    }

    function getfail() public view returns(bytes memory){
        return fail;
    }

    function setSwapEnable(bool enable) public onlyOwner {
        _canSwap = enable;
    }

    function setTransferEnable(bool enable) public onlyOwner {
        _canTransfer = enable;
    }

    function setRepayEnable(bool enable) public onlyOwner {
        _canRepay = enable;
    }

    function getExcluded() public view onlyOwner returns (address[] memory) {
        return _excluded;
    }
}