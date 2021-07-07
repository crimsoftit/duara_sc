// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";
import "./DateLib.sol";

contract DemAssets is Ownable {
    uint256 public assetCount;
    Asset[] public assets;

    // defines an asset
    struct Asset {
        bytes32 code; //unique id (barcode)
        string assetName;
    }
    
    mapping(bytes32 => uint) assetCodeToIndex; 
    mapping (uint256 => Asset) public demAssets;

    event AssetCreated(bytes32 code, string name, uint256 assetNumber);

    bytes32 public assetCode;

    constructor() public {
        assetCode = stringToBytes32("vini_code");
        demAssets[0] = Asset(assetCode, "test");
        //assets.push(Asset(assetCode, "test_tena"));
		assetCount = 1;
    }

    function _getAssetIndex(bytes32 _assetCode) public view returns (uint) {
        return assetCodeToIndex[_assetCode]-1; 
    }

    // function getAssetByCode (string memory _assetCode) public view returns (string memory name) {
    //     string memory theAsset = assets[_assetCode].assetName;
    //     return theAsset;
    // }

    function createAsset(string memory _code, string memory _assetName) onlyOwner public {

        bytes32 code = stringToBytes32(_code);
        demAssets[assetCount++] = Asset(code, _assetName);
        
        uint newIndex = assets.push(Asset(code, _assetName))-1;
        assetCodeToIndex[code] = newIndex+1;

        emit AssetCreated(code, _assetName, assetCount - 1);
    }

    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function bytes32ToStr(bytes32 _bytes32) public pure returns (string memory) {
        bytes32 theString = _bytes32;
        string memory res = string(abi.encodePacked(theString));
        return string(res);
    }

    function addTestData() external onlyOwner {
        createAsset("manu_code", "manu");
    }
}

























