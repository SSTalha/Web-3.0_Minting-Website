// SPDX-License-Identifier: UNLICENSED 

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol'; // contract that will be used for minting
import '@openzeppelin/contracts/access/Ownable.sol'; // To define functios only the owner can use

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri; // Detemine where the images are located through url
    address payable public withdrawWallet; //Used to withdraw the money from the wallet not gonna use but might do
    mapping(address => uint256) public walletMints; //keep track of all the mints (how many each wallet has minted)


    constructor() payable ERC721('RoboPunks', 'RP'){
        //Initialize the variables
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
        //set withdraw wallet address
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {

        //Only the owner can call this function
        isPublicMintEnabled = isPublicMintEnabled_;

    }


    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner{

        baseTokenUri = baseTokenUri_;
    }

    function tokenURI(uint256 tokenId_) public view override returns (string memory){
        require(_exists(tokenId_), 'Token does not exist!');
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), ".json"));  // This func grabs the if of the img and puts it behind the url and attach json to the end
    }

    function withdraw() external onlyOwner{
        (bool success, ) = withdrawWallet.call{value: address(this).balance }('');
        require(success, 'Withdraw Failed');

    }        


    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, 'minting is not enabled');
        require(msg.value == quantity_ * mintPrice, 'wrong mint value'); // To ensure the user is entering the correct mint value
        require(totalSupply + quantity_ <= maxSupply , 'sold out');
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, 'exceed max wallet');

        for(uint256 i = 0; i < quantity_; i++){
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }

}