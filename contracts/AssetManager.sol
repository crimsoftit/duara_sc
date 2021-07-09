// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AssetManager {
    uint256 public assetCount;
    bytes32 public assetCode;

    struct Asset {
        bytes32 code; //unique id (barcode)
        string assetName;
    }

    mapping(uint256 => Asset) public assets;

    mapping(bytes32 => string) getNameFromCode;

    event AssetCreated(string asset, uint256 assetNumber);

    constructor() public {
        assetCode = stringToBytes32("vini_code");
        assets[0] = Asset(assetCode, "test");
        assetCount = 1;
    }

    function createAsset(string memory _code, string memory _assetName) public {
        bytes32 code = stringToBytes32(_code);
        assets[assetCount++] = Asset(code, _assetName);
        getNameFromCode[code] = _assetName;

        emit AssetCreated(_assetName, assetCount - 1);
    }

    function getAssetByCode (string memory _assetCode) public view returns (string memory) {
        bytes32 theCode = stringToBytes32(_assetCode);
        return getNameFromCode[theCode];
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

    function addTestData() public {
        createAsset("manu_code", "manu");
        createAsset("bili_code", "bili");
    }
}
