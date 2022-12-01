// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
   


import "./libs/TransferHelp.sol";
import "./libs/SafeMath.sol";

contract NftMetaSMA is ERC721Enumerable, Ownable ,ReentrancyGuard{
    using Strings for uint256;
    using SafeMath for uint256;

    uint256 public nftPrice;

    IERC20 public paytoken;

    mapping(uint256 => string) private _tokenURIs;

    address[] private _blocked;  //black list
    address private priceSetter;

    address public rootAddress;

    mapping(address => bool) private _isBlocked;
    mapping(address => address) public inviterMe;  

    struct OrderInfo {
		uint256 payAmount;
k;
        address initMintUser;
    }

    mapping (uint256=>OrderInfo) public nftOrder;
    mapping (address=>uint256) public myNftRewards;

    uint256 public preNftRewards;
    uint256 public lastRefreshBlock;
    ys;

    bool public _isSaleActive = false;

    bool public _revealed = false;
   


    uint256 public maxMint = 10;
   
    string baseURI;

    string public notRevealedUri;

    string public baseExtension = ".json";
   
    event InviterSetted(address indexed inviter,address user, uint256 settime);
   

    constructor(string memory initBaseURI, string memory initNotRevealedUri, uint256 _blocksperday,
            address _pricesetter, address _rootaddress, IERC20 _paytoken) ERC721("ShibMutualAid NFT", "SMANFT") {
        require(_blocksperday>0 && _pricesetter != address(0), "error parameter");
        setBaseURI(initBaseURI);
        setNotRevealedURI(initNotRevealedUri);
        lastRefreshBlock = 0;
        lastNftCounts = 0;
        preNftRewards = 0;

        paytoken = _paytoken;
        rootAddress = _rootaddress;
    } 

    function tokensOfOwner(address _owner) external view returns (uint[] memory) {
        uint tokenCount = balanceOf(_owner);


        for (uint i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    function setSnowToken(IERC20 _snowtoken) public onlyOwner {
        require(address(_snowtoken) != address(0) && isContract(address(_snowtoken)), "Error Token address");
        _snowToken = _snowtoken;
    }
    
    function autoSetInviter(address account, address newinviter) external returns(bool){
        bool isok = false;

        require(from == address(_snowToken) && address(_snowToken) !=address(0), "token error or not seted");
        
        if (_isBlocked[newinviter] || _isBlocked[account] || inviterMe[account] != address(0)
            || newinviter == address(0) || isContract(newinviter) || isContract(account)){
             _needsetinviter = false;
             return isok;
        }

        address _newinviterups = inviterMe[newinviter];
        if (_newinviterups==address(0) && _newinviterups != rootAddress){
             _needsetinviter = false;
             return isok;            
        }
        while (_newinviterups!=address(0)) {
            if (_newinviterups == account){
                // require(_newinviterups != account, "you are higher ups of newinviter");

            }else{
                _newinviterups = inviterMe[_newinviterups];
            }
        }
        
        if (_needsetinviter){
            inviterMe[account] = newinviter;
            emit InviterSetted(newinviter, account, block.timestamp);
            isok = true;
        }

        return isok;        
    }

    function setInviter(address newinviter) external returns(bool){
        bool isok = false;
        address account = msg.sender;
        require(!_isBlocked[newinviter] && !_isBlocked[account], "your address or inviter address has blocked");
        require(!isContract(account), "account can not be contract address");


        address _newinviterups = inviterMe[newinviter];
        if (newinviter != rootAddress){
            require(_newinviterups!=address(0),"new inviter invaild");
            while (_newinviterups!=address(0)) {
                require(_newinviterups != account && !_isBlocked[_newinviterups], "you are higher ups of newinviter or have blocked ups");
                _newinviterups = inviterMe[_newinviterups];
            }
        }

        inviterMe[account] = newinviter;
        emit InviterSetted(newinviter, account, block.timestamp);

        isok = true;
        return isok;
    }

    function getInviter() public view returns (address) {

        return inviterMe[account];
    }

    function getAnyInviter(address account) public view returns (address) {
        return inviterMe[account];
    }

    function isBlocked(address account) public view returns (bool) {
        return _isBlocked[account];
    }

    function getBlocked() public view onlyOwner returns (address[] memory) {
        return _blocked;
    }


        require(priceSetter !=address(0) && from == priceSetter, "invaild from");

    }

    function setBlocked(address account,bool isBlock) public onlyOwner returns(bool){
        require(account != owner() && account != address(0),"Can't set owner or zero");
        bool isok = false;
        bool _isblock = isBlock;
        if (_isblock){
            require(!_isBlocked[account], "Address already blocked!");
            isok = true;
            _isBlocked[account] = true;
            _blocked.push(account);

        }else{
            require(_isBlocked[account], "Address not blocked!");
            
            for (uint256 i = 0; i < _blocked.length; i++) {
                if (_blocked[i] == account) {
                    isok = true;
                    _blocked[i] = _blocked[_blocked.length - 1];
                    _isBlocked[account] = false;
                    _blocked.pop();
                    break;
                }
            }
        }
        return isok;
    }

    function setIdoFinished(bool _isFinished) public onlyOwner {
        _isSaleActive = _isFinished;
    }

    //处理nft奖励池扎帐事宜
    function refreshNftRewards(uint256 curblock) external returns(bool){

        require(((from == address(_snowToken) && address(_snowToken) !=address(0)) || from == address(this))
            && curblock>0, "token error or not seted");
        if ((curblock.sub(lastRefreshBlock)) >= (refreshRewardsDays.mul(blocksPerDay))){
            preNftRewards = IERC20(_snowToken).balanceOf(address(this));
            lastNftCounts = totalSupply();

            if (preNftRewards>0 && lastNftCounts>0){
                lastRefreshBlock = curblock;
            }
        }
        return isok;
    }

    function getUsrIdoAmount(address account) external view returns(uint256) {
        uint tokenCount = balanceOf(account);
        uint atokensId;
        uint256 idoamount = 0;
        if (tokenCount>0){
            for (uint i = 0; i < tokenCount; i++) {
                atokensId = tokenOfOwnerByIndex(account, i);
                idoamount = idoamount.add(nftOrder[atokensId].payAmount);
            }
        }
        return idoamount;
    }

    function canTakeNftRewards(address account) external view returns(bool){
        uint tokenCount = balanceOf(account);
        uint atokensId;
        bool isok = false;
        if (tokenCount>0 && preNftRewards>0 && lastNftCounts>0){

                atokensId = tokenOfOwnerByIndex(account, i);
                if (nftOrder[atokensId].lastGetRefreshBlock != lastRefreshBlock && 
                        atokensId < lastNftCounts){
                    isok = true;
                    break;
                }
            }
        }
        return isok;
    }
    
    function takeNftRewards() nonReentrant external returns(bool){        
        bool isok = false;
        address from = _msgSender();
        
        require(from != address(0) && address(_snowToken) !=address(0), "token error or not seted");
        require(!_isBlocked[from], "address blocked");

        uint atokensId;
        uint tokenCount = balanceOf(from);
        uint256 ttRewards = 0;
        uint256 oneRewards = 0;
        if (tokenCount>0 && preNftRewards>0 && lastNftCounts>0){
            oneRewards = preNftRewards.div(lastNftCounts);

                if (nftOrder[atokensId].lastGetRefreshBlock != lastRefreshBlock && 
                        atokensId < lastNftCounts){
                    nftOrder[atokensId].lastGetRefreshBlock = lastRefreshBlock;
                    ttRewards = ttRewards.add(oneRewards);
                    isok = true;
                }
            }
            if (ttRewards>0){
                TransferHelper.safeTransfer(address(_snowToken), from, ttRewards);
                myNftRewards[from] = myNftRewards[from].add(ttRewards);
            }

        }
        return isok;
    }
    
    receive() external payable {}

    function mintNftMeta(uint256 tokenQuantity) public {
        address from = _msgSender();
        require(address(paytoken) != address(0), "Pay token is not set");
        require(nftPrice>0, "nft price not set");
        
        require(
            totalSupply() + tokenQuantity <= MAX_SUPPLY,
            "Sale would exceed max supply"
        );

        require(_isSaleActive, "Sale paused");

        require( 
            balanceOf(from) + tokenQuantity <= maxBalance,
            "Sale would exceed max balance"
        );


        require(tokenQuantity <= maxMint, "Can only mint 1 tokens at a time");

        uint256 minAmount = IERC20(paytoken).allowance(from, address(this));
        require(minAmount >= tokenQuantity.mul(nftPrice), "Approved allowance not enough");
        TransferHelper.safeTransferFrom(address(paytoken), from, address(this), tokenQuantity.mul(nftPrice));
        if (inviterMe[from]!=address(0)){
            TransferHelper.safeTransfer(address(paytoken), inviterMe[from], (tokenQuantity.mul(nftPrice)).mul(10).div(100));
        }
        

    }
   
    function _mintNftMeta(address from,uint256 tokenQuantity) internal {
        for (uint256 i = 0; i < tokenQuantity; i++) {

            uint256 mintIndex = totalSupply();
            if (totalSupply() < MAX_SUPPLY) {

                _safeMint(from, mintIndex);
                nftOrder[mintIndex].payAmount = nftPrice;
		        nftOrder[mintIndex].idoTime = block.timestamp;
                nftOrder[mintIndex].lastGetRefreshBlock = 0;
                nftOrder[mintIndex].initMintUser = from;
            }
        }
    }
   

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
   

        if (_revealed == false) {
            return notRevealedUri;
        }
   
        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();
   
        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

            string(abi.encodePacked(base, tokenId.toString(), baseExtension));
    }
   
    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
   
    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    }
      
    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }
   
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
   
    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }
   

   
    function setMaxMint(uint256 _maxMint) public onlyOwner {
        maxMint = _maxMint;
    }
   
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function claimTokens() public onlyOwner {
        address theowner = owner();
        if (theowner != address(0)){
            TransferHelper.safeTransferETH(theowner, address(this).balance);
        }
    }

    
    function claimOtherTokens(IERC20 token,address to, uint256 amount) public onlyOwner {
        require(to != address(this) && to != address(0) && address(token) != address(0), "Error target address");
        uint256 abalance;
        abalance = token.balanceOf(address(this));
        require(amount <= abalance && amount>0, "Insufficient funds");

        TransferHelper.safeTransfer(address(token), to, amount);
    }

    function transferPriceSetter(address newSetter) public {
        address from = msg.sender;
        require(from == priceSetter, "invaild sender");
        require(newSetter != address(0) && newSetter != priceSetter, "Ownable: new owner is the zero address");
        
        priceSetter = newSetter;
    }

}