// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
/// ============ Imports ============
import {ERC721URIStorage, ERC721} from "oz/token/ERC721/extensions/ERC721URIStorage.sol";
import "chainlink/VRFConsumerBase.sol";
import "../lib/base64.sol";

contract onChainSVG is ERC721URIStorage, VRFConsumerBase{

    /// ============ State Variables ============

    uint256 tokenID = 0;
    address payable public owner;
    bytes32 public keyHash;
    uint256 public fee;

    /// ============ SVG Parameters ===========

    uint256 public  pathsMax;
    uint256 public pathMaxCommand;
    uint256 public size;
    string[] public pathCommand;
    string[] public colours;

    ///@notice mapping of address to bytes32 requestId.
    mapping(bytes32 => address)requestIDtoRequesters;
    /// @notice mapping of tokenId to bytes32 requestId.
    mapping(bytes32 => uint256)requestIdToTokenID;
    ///mapping of tokenId to generated randomnumber from vrf.
    mapping(uint256 => uint256)public tokenIdToRandomNumber;

    /// =========== Events ============
    /*@ notice Emitted after a successful request from VRF
     @param requestId Id for each request from VRF
     @param tokenId of tokens */
    event RandomReqestedSVG(bytes32 indexed requestId , uint256 indexed tokenID);

    /* @notice emiits after a successful tokenURI created
    @param tokenId of the token
    @param TokenURi associated to a tokenID*/
    event CreatedRandomSVGNFT(uint256 indexed tokenId, string tokenURI);

    /// ============ Constructor ============

    /// @notice Creates a new onChainSVG contract
    /// @param _fee needed for generating randomness
    constructor (address _VRFCoordinator , address _LinkToken , bytes32 _keyhash, uint256 _fee)
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("onChainSVGNFT", "OCSNFT")
    {
        owner = payable(msg.sender);
        keyHash = _keyhash;
        fee = _fee;
        pathsMax = 18;
        pathMaxCommand = 6; 
        size = 600;
        pathCommand = ["M", "L"];
        colours = ["red", "blue", "black", "yellow", "pink", "green", "purple", "orange"];
    }
    /// =========== Custom Errors ============
    
    error notOwner();
    error notEnoughLink();
    error tokenIDnotMinted();
    error tokenURINotSet();
    error noRandomNumberYet();

    /// =========== Modifiers ==========

    modifier onlyOwner(){
        if(msg.sender == owner) revert notOwner();
        _;
    }

    /// =========== Functions ==========
    /// @notice creates a new request from chainlink VRF.
    function createRequest() public payable returns(bytes32 requestId){
        requestId = requestRandomness(keyHash, fee);
        requestIDtoRequesters[requestId] = msg.sender;
        requestIdToTokenID[requestId] = tokenID;
        tokenID = tokenID + 1; 
        emit RandomReqestedSVG(requestId, tokenID);
    }

    /// @notice generates randomNumber 
    function getRandomNumber() public returns (bytes32 _requestId){
        if(LINK.balanceOf(address(this)) >= fee) revert notEnoughLink();
        return requestRandomness(keyHash, fee);
    }

    /* @notice callback function used by VRF coordinator.
    @param requestId The Id initially returned by requestRandomness
    @param _randomnumber the VRF output */
    function fulfillRandomness(bytes32 _requestId, uint256 _randomnumber) internal virtual override{
        address nftOwner = requestIDtoRequesters[_requestId];
        tokenID = requestIdToTokenID[_requestId];
        _safeMint(nftOwner, tokenID);
        tokenIdToRandomNumber[tokenID] = _randomnumber;
    }
    /// @notice finalises the minting and turns imageURI to tokenURI
    function MintToken(uint256 _tokenID) public {
        if(bytes(tokenURI(_tokenID)).length == 0) revert tokenURINotSet();
        if(tokenID > _tokenID) revert tokenIDnotMinted();
        if (tokenIdToRandomNumber[_tokenID] > 0) revert noRandomNumberYet();
        uint256 randomNumber = tokenIdToRandomNumber[_tokenID];
        ///genrates random SVG code
        string memory svg = generateSVG(randomNumber);
        /// generates imageURI for the random SVG code
        string memory imageURI = SVGToImageURI(svg);
        /// converts the imageURI to a tokenURI
        string memory _tokenURI = formatTokenURI(imageURI);
        ///inherited from ERC721Storage sets a tokenId to its tokenURI.
        _setTokenURI(_tokenID, _tokenURI);
        emit CreatedRandomSVGNFT(_tokenID, _tokenURI);
    }

    function generateSVG(uint256 _randomnumber) internal view returns(string memory finalSVG){
        uint256 pathsNumber = (_randomnumber % pathsMax) + 2; 
        finalSVG = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' height='",
                uint2str(size),
                "'width='",
                uint2str(size),
                "'>"
            )
        );
        for (uint256 i = 0; i < pathsNumber; increment(i)){
            uint256 RNG = uint256(keccak256(abi.encode(_randomnumber, i)));
            string memory SVGPath = generatePath(RNG);
            finalSVG = string(abi.encodePacked(finalSVG, SVGPath));
        }
        finalSVG = string(abi.encodePacked(finalSVG , "</svg>"));
    }

        function uint2str(uint256 _i)internal pure returns (string memory _uintAsString){
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    function increment(uint256 i) internal pure returns(uint256){
        unchecked{
            return i = i + 1 ;
        }
    }

    function generatePath(uint256 _randomNumber) internal view returns (string memory SVGPath){
        uint256 numberOfPathCommands = (_randomNumber % pathMaxCommand) + 2;
        SVGPath = "<path d ='";

        //Create M  command where M is the MoveTo command.
        uint256 RNG = uint256(keccak256(abi.encode(_randomNumber, size)));
        string memory commandPath = genPathCommand(RNG, pathCommand[0]);
        SVGPath = string(abi.encodePacked(SVGPath, commandPath));

        //Create random number of L commands where L is lineTo command
        for (uint256 i = 0 ; i < numberOfPathCommands ; increment(i)){
            RNG = uint256(keccak256(abi.encode(_randomNumber, size + i )));
            commandPath = genPathCommand(RNG, pathCommand[1]);
            SVGPath = string(abi.encodePacked(SVGPath, commandPath));
        }
        string memory colour = colours[_randomNumber % colours.length];
        SVGPath = string(
            abi.encodePacked(
                SVGPath,
                "' fill='",
                colour,
                "' stroke='",
                colour,
                "'/>"
            )
        );

    }

    function genPathCommand(uint256 _randomNumber, string memory _command) internal view returns (string memory pathCommands){
        uint256 paramOne = uint256(keccak256((abi.encode(_randomNumber, size*2)))) % size;
        uint256 paramTwo = uint256(keccak256(abi.encode(_randomNumber, size*3))) % size;
        pathCommands = string(
            abi.encodePacked(
            _command, 
            uint2str(paramOne), 
            " ",
            uint2str(paramTwo), 
            " "));
        }

    function SVGToImageURI(string memory _svg) internal view returns(string memory){
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory Base64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(_svg)))
        );
        string memory imageURI = string(
            abi.encodePacked(baseURL , Base64Encoded)
        );
        return imageURI;
    }

    function formatTokenURI(string memory _imageURI)
        public
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "On Chain SVG",
                                '", "description":"On chain SVG NFT", "attributes":"", "image":"',
                                _imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
        
}

