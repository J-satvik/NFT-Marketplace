// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//INTERNAL IMPORT FOR NFT FROM OPENZEPPELIN
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    uint256 listingPrice = 0.0025 ether ;
    address payable owner;

    mapping(uint256 => MarketItem) private idMarketitem;

    struct MarketItem{
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event idMarketitemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    modifier onlyOwner(){
        require(msg.sender==owner,"only owner of the marketplace can change the listing price");
        _;
    } 
    
    constructor() ERC721("NFT Metaverse Token","MYNFT"){
        owner = payable(msg.sender);

    }
    function updateListingPrice(uint256 _listingPrice)
     public payable onlyOwner(){

        listingPrice = _listingPrice;
    }

    function getListingPrice() public view returns(uint256){
        return listingPrice;
    }
    //LETS CREATE "NFT TOKEN FUNCTION"
    function createToken(string memory tokenURI, uint256 price) public payable returns(uint256){
        _tokenIds.increment(); 

        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender,newTokenId);
        _setTokenURI(newTokenId,tokenURI);

        createMarketItem(newTokenId,price);

        return newTokenId;


    }

    //CREATING MARKET ITEMS
    function createMarketItem(uint256 tokenId , uint256 price ) private{
        require(price > 0,"Price must be atleat 1");
        require(msg.value== listingPrice,"Price must be equal to lising");

        idMarketitem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender,address(this),tokenId);

        emit idMarketitemCreated(tokenId, msg.sender,address(this),  price, false);
    }
    //FUNNCTION FOR RESALE
    function reSellToken(uint256 tokenId, uint256 price) public payable{

        require(idMarketitem[tokenId].owner==msg.sender,"Only Item owner can perform this operations");
        require(msg.value==listingPrice,"Price must be equal to listing price");


        idMarketitem[tokenId].sold= false;
        idMarketitem[tokenId].price= price;
        idMarketitem[tokenId].seller= payable(msg.sender);
        idMarketitem[tokenId].owner = payable(address(this));

        _itemsSold.decrement();
        _transfer(msg.sender,address(this),tokenId);
    }

    //FUNCTION CREATEMARKETSALE
    function createMarketSell(uint256 tokenId) public payable{
        uint256 price = idMarketitem[tokenId].price;

        require(msg.value == price,"Please submit asking price in order to complete the purchase" );
        idMarketitem[tokenId].owner = payable(msg.sender);
        idMarketitem[tokenId].sold = false;
        idMarketitem[tokenId].owner = payable(address(0));


        _itemsSold.increment();

        _transfer(address(this),msg.sender,tokenId);

        payable(owner).transfer(listingPrice);
        payable(idMarketitem[tokenId].seller).transfer(msg.value);

    }



    //GETTING UNSOLD NFT DATA
    function fetchMarketItem() public view returns(MarketItem[] memory){
        uint256 itemCount = _tokenIds.current();
        uint256 unSoldItemCount =  _tokenIds.current()  - _itemsSold.current();
        uint256 currentIndex = 0;


        MarketItem[] memory items = new MarketItem[](unSoldItemCount);
        for(uint256 i =0;i<itemCount;i++){
            if(idMarketitem[i+1].owner==address(this)){
                uint256 currentId = i+1;

                MarketItem storage currentItem =    idMarketitem[currentId];
                items[currentIndex] = currentItem;
                currentIndex +=1;
                 
            }
        }
        return items;
    }
    // PURCHASE ITEM
    function fetchMyNFT()public view returns(MarketItem[] memory){
         uint256 totalCount = _tokenIds.current();
         uint256 itemCount =0;
         uint256 currentIndex = 0;

        for(uint256 i =0;i< totalCount;i++){
            if(idMarketitem[1+1].owner==msg.sender){
                itemCount +=1;
            }
        }

        MarketItem[]  memory items = new MarketItem[](itemCount);
        for(uint256 i =0;i< totalCount;i++){
            if(idMarketitem[i+1].owner==msg.sender){
            uint256 currentId = 1 +1;
            MarketItem storage currentItem = idMarketitem[currentId];
            items[currentIndex] = currentItem;
            currentIndex +=1;

            }

        }
        return items;
    }
    //SINGLE USER ITEMS
     function fetchItemsListed() public view returns(MarketItem[] memory){
        uint256 totalCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex =0;

        for(uint256 i =0;i< totalCount;i++){
            if(idMarketitem[i+1].seller==msg.sender){
                itemCount+=1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for(uint256 i =0;i< totalCount;i++){
            if(idMarketitem[i+1].seller==msg.sender){
                uint256 currentId = i+1;

                MarketItem storage currentItem = idMarketitem[currentId];
                items[currentIndex] = currentItem;
                currentIndex +=1;
            }
        }
        return items;

     }
}


