// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "contracts/Ownable.sol";
import "contracts/DateLib.sol";

contract AssetManager is Ownable {
    uint256 public assetCount;
    string public theCode;
    string public theName;

    struct Asset {
        string code; //unique id (barcode)
        string assetName;
    }

    mapping(uint256 => Asset) public assets;

    mapping(string => string) public getNameFromCode;

    event AssetCreated(string asset, uint256 assetNumber);

    constructor() public {
        theCode = "vini_code";
        theName = "vini";
        assets[0] = Asset(theCode, theName);        
        //getNameFromCode["vini_code"] = "test";
        assetCount = 1;
    }

    function createAsset(string memory _code, string memory _assetName) onlyOwner public {
        assets[assetCount++] = Asset(_code, _assetName);
        //getNameFromCode[_code] = _assetName;

        emit AssetCreated(_assetName, assetCount - 1);
    }

    // function getAssetByCode (string memory _assetCode) public view returns (string memory) {
    //     return getNameFromCode[_assetCode];
    // }
   
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

    function addTestData() public {
        createAsset("manu_code", "manu");
        createAsset("bili_code", "bili");
    }
}
