pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";
import "./DateLib.sol";


contract AssetManager is Ownable {
    uint256 public assetCount;
    Asset[] assets; 
    mapping(bytes32 => uint) assetIdToIndex; 
    mapping (uint256 => Asset) public demAssets;

    using DateLib for DateLib.DateTime;

    // defines an asset
    struct Asset {
        bytes32 id; //unique id (barcode)
        string name;
    }

    event assetFetched (string fetchedAssetName);

    bytes32 public assetID;

    constructor () public {
        assetID = stringToBytes32("vini_code");
        demAssets[0] = Asset(assetID, "test");
        assets.push(Asset(assetID, "test"));
		assetCount = 1;
	}

    /// @notice returns the array index of the match with the given id 
    /// @dev if the match id is invalid, then the return value will be incorrect and may cause error; you must call matchExists(_matchId) first!
    /// @param _assetId the match id to get
    /// @return an array index 

    function _getAssetIndex(bytes32 _assetId) private view returns (uint) {
        return assetIdToIndex[_assetId]-1; 
    }


    /// @notice determines whether a match exists with the given id 
    /// @param _assetId the match id to test
    /// @return true if match exists and id is valid
    function assetExists(bytes32 _assetId) public view returns (bool) {
        if (assets.length == 0)
            return false;
        uint index = assetIdToIndex[_assetId]; 
        return (index > 0); 
    }

    function createAsset(string memory _id, string memory _name) onlyOwner public returns (bytes32) {

        bytes32 id = stringToBytes32(_id);

        //require that the asset be unique (not already added) 
        require(!assetExists(id));
        
        //add the asset 
        uint newIndex = assets.push(Asset(id, _name))-1; 
        assetIdToIndex[id] = newIndex+1;
        demAssets[assetCount++] = Asset(id, _name);
        //return the unique id of the new asset
        return id;
    }    
    function getAllAssets() public view returns (bytes32[] memory) {
        bytes32[] memory output = new bytes32[](assets.length);

        //get all ids 
        if (assets.length > 0) {
            uint index = 0;
            for (uint n = assets.length; n > 0; n--) {
                output[index++] = assets[n-1].id;
            }
        }
        
        return output; 
    }

    function getTAssets() public view returns (bytes32[] memory) {
        bytes32[] memory output = new bytes32[](assetCount);

        //get all ids 
        if (assetCount > 0) {
            uint index = 0;
            for (uint n = assetCount; n > 0; n--) {
                output[index++] = demAssets[n-1].id;
            }
        }
        
        return output; 
    }

    function getAssetByCode(string memory _assetId) public returns (
        bytes32 id,
        string memory name) {
        
        //get the match 
        // if (assetExists(_assetId)) {
        //     Asset storage theAsset = assets[_getAssetIndex(_assetId)];
        //     return (theAsset.id, theAsset.name); 
        // }
        // else {
        //     return (_assetId, -1); 
        // }
        Asset storage theAsset = assets[_getAssetIndex(stringToBytes32(_assetId))];
        emit assetFetched (theAsset.name);

        return (theAsset.id, theAsset.name);
    }
    function testConnection() public pure returns (bool) {
        return true; 
    }

    function addTestData() external onlyOwner {
        createAsset("manu_code", "Pacquiao vs. MayWeather");
        createAsset("bili_code", "ligi vs. ndogo");
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

}
