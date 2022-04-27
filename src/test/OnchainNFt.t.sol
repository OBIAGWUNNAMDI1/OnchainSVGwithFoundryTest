// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "../OnchainNft.sol";
import "chainlink/VRFConsumerBase.sol";
import "../IERC20.sol";
import "chainlink/interfaces/LinkTokenInterface.sol";

contract NFTtest is DSTest{
    onChainSVG  onchain;
    address link_token = 0xa36085F69e2889c224210F603D836748e7dC0088;
    address vrfCoordinator = 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9;
    bytes32 keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
    uint256 fee = 10000000000000000000;
    address contractSVG = 0xc32C21b489542134d21219f3326DaB07fdB2A985;


    function setUp() public{
        onchain = new onChainSVG(vrfCoordinator, link_token, keyHash, fee);
        
        
    }

    function testCreateRequest() public {
        bytes32 createRequests = onchain.createRequest();
    
    }
    //  function testgetRandomNumber() public {
    //     //assertEq(LinkTokenInterface(link_token).balanceOf(contractSVG)> fee) ;
            
    //     onchain.MintToken(0);
    // }


}