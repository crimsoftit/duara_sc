pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";
import "./DateLib.sol";


contract BoxingOracle is Ownable {
    Match[] matches; 
    mapping(bytes32 => uint) matchIdToIndex; 

    using DateLib for DateLib.DateTime;

    //defines a match along with its outcome
    struct Match {
        bytes32 id;             //unique id
        string name;            //human-friendly name (e.g. Jones vs. Holloway)
        string participants;    //a delimited string of participant names
        uint8 participantCount; //number of participants (always 2 for boxing matches!) 
        uint date;              //GMT timestamp of date of contest
        MatchOutcome outcome;   //the outcome (if decided)
        int8 winner;            //index of the participant who is the winner
    }

    //possible match outcomes 
    enum MatchOutcome {
        Pending,    //match has not been fought to decision
        Underway,   //match has started & is underway
        Draw,       //anything other than a clear winner (e.g. cancelled)
        Decided     //index of participant who is the winner 
    }


    /// @notice returns the array index of the match with the given id 
    /// @dev if the match id is invalid, then the return value will be incorrect and may cause error; you must call matchExists(_matchId) first!
    /// @param _matchId the match id to get
    /// @return an array index 

    function _getMatchIndex(bytes32 _matchId) private view returns (uint) {
        return matchIdToIndex[_matchId]-1; 
    }


    /// @notice determines whether a match exists with the given id 
    /// @param _matchId the match id to test
    /// @return true if match exists and id is valid
    function matchExists(bytes32 _matchId) public view returns (bool) {
        if (matches.length == 0)
            return false;
        uint index = matchIdToIndex[_matchId]; 
        return (index > 0); 
    }

    /// @notice sets the outcome of a predefined match, permanently on the blockchain
    /// @param _matchId unique id of the match to modify
    /// @param _outcome outcome of the match 

    function declareOutcome(bytes32 _matchId, MatchOutcome _outcome, int8 _winner) onlyOwner external {
        //require that it exists
        require(matchExists(_matchId)); 

        //get the match 
        uint index = _getMatchIndex(_matchId);
        Match storage theMatch = matches[index]; 

        if (_outcome == MatchOutcome.Decided) 
            require(_winner >= 0 && theMatch.participantCount > uint8(_winner)); 

        //set the outcome 
        theMatch.outcome = _outcome;
        
        //set the winner (if there is one)
        if (_outcome == MatchOutcome.Decided) 
            theMatch.winner = _winner;
    }

    /// @notice puts a new pending match into the blockchain 
    /// @param _name descriptive name for the match (e.g. Pac vs. Mayweather 2016)
    /// @param _participants |-delimited string of participants names (e.g. "Manny Pac|Floyd May")
    /// @param _participantCount number of participants 
    /// @param _date date set for the match 
    /// @return the unique id of the newly created match 

    function addMatch(string memory _id, string memory _name, string memory _participants, uint8 _participantCount, uint _date) onlyOwner public returns (bytes32) {

        //hash the crucial info to get a unique id 
        //bytes32 id = keccak256(abi.encodePacked(_name, _participantCount, _date)); 
        //string memory theCode = "manu_code";

        bytes32 id = stringToBytes32(_id);

        //require that the match be unique (not already added) 
        require(!matchExists(id));
        
        //add the match 
        uint newIndex = matches.push(Match(id, _name, _participants, _participantCount, _date, MatchOutcome.Pending, -1))-1; 
        matchIdToIndex[id] = newIndex+1;
        
        //return the unique id of the new match
        return id;
    }

    

    /// @notice gets the unique ids of all pending matches, in reverse chronological order
    /// @return an array of unique match ids
    function getPendingMatches() public view returns (bytes32[] memory) {
        uint count = 0; 

        //get count of pending matches 
        for (uint i = 0; i < matches.length; i++) {
            if (matches[i].outcome == MatchOutcome.Pending) 
                count++; 
        }

        //collect up all the pending matches
        bytes32[] memory output = new bytes32[](count); 

        if (count > 0) {
            uint index = 0;
            for (uint n = matches.length; n > 0; n--) {
                if (matches[n-1].outcome == MatchOutcome.Pending) 
                    output[index++] = matches[n-1].id;
            }
        } 

        return output; 
    }

    /// @notice gets the unique ids of matches, pending and decided, in reverse chronological order
    /// @return an array of unique match ids
    function getAllMatches() public view returns (bytes32[] memory) {
        bytes32[] memory output = new bytes32[](matches.length);

        //get all ids 
        if (matches.length > 0) {
            uint index = 0;
            for (uint n = matches.length; n > 0; n--) {
                output[index++] = matches[n-1].id;
            }
        }
        
        return output; 
    }

    /// @notice gets the specified match 
    /// @param _matchId the unique id of the desired match 
    /// @return match data of the specified match 
    function getMatch(bytes32 _matchId) public view returns (
        bytes32 id,
        string memory name, 
        string memory participants,
        uint8 participantCount,
        uint date, 
        MatchOutcome outcome, 
        int8 winner) {
        
        //get the match 
        // if (matchExists(_matchId)) {
        //     Match storage theMatch = matches[_getMatchIndex(_matchId)];
        //     return (theMatch.id, theMatch.name, theMatch.participants, theMatch.participantCount, theMatch.date, theMatch.outcome, theMatch.winner); 
        // }
        // else {
        //     return (_matchId, "", "", 0, 0, MatchOutcome.Pending, -1); 
        // }
        Match storage theMatch = matches[_getMatchIndex(_matchId)];

        return (theMatch.id, theMatch.name, theMatch.participants, theMatch.participantCount, theMatch.date, theMatch.outcome, theMatch.winner);
    }



    function getTheMatch(string memory _matchId) public view returns (
        bytes32 id,
        string memory name, 
        string memory participants,
        uint8 participantCount,
        uint date, 
        MatchOutcome outcome, 
        int8 winner) {
        
        //get the match 
        // if (matchExists(_matchId)) {
        //     Match storage theMatch = matches[_getMatchIndex(_matchId)];
        //     return (theMatch.id, theMatch.name, theMatch.participants, theMatch.participantCount, theMatch.date, theMatch.outcome, theMatch.winner); 
        // }
        // else {
        //     return (_matchId, "", "", 0, 0, MatchOutcome.Pending, -1); 
        // }
        Match storage theMatch = matches[_getMatchIndex(stringToBytes32(_matchId))];

        return (theMatch.id, theMatch.name, theMatch.participants, theMatch.participantCount, theMatch.date, theMatch.outcome, theMatch.winner);
    }




    /// @notice gets the most recent match or pending match 
    /// @param _pending if true, will return only the most recent pending match; otherwise, returns the most recent match either pending or completed
    /// @return match data 
    function getMostRecentMatch(bool _pending) public view returns (
        bytes32 id,
        string memory name, 
        string memory participants,
        uint8 participantCount,
        uint date, 
        MatchOutcome outcome, 
        int8 winner) {

        bytes32 matchId = 0; 
        bytes32[] memory ids;

        if (_pending) {
            ids = getPendingMatches(); 
        } else {
            ids = getAllMatches();
        }
        if (ids.length > 0) {
            matchId = ids[0]; 
        }
        
        //by default, return a null match
        return getMatch(matchId); 
    }

    function testConnection() public pure returns (bool) {
        return true; 
    }

    function addTestData() external onlyOwner {
        addMatch("manu_code", "Pacquiao vs. MayWeather", "Pacquiao|Mayweather", 2, now);
        // addMatch("Macquiao vs. Payweather", "Macquiao|Payweather", 2, DateLib.DateTime(2018, 8, 15, 0, 0, 0, 0, 0).toUnixTimestamp());
        // addMatch("Pacweather vs. Macarthur", "Pacweather|Macarthur", 2, DateLib.DateTime(2018, 9, 3, 0, 0, 0, 0, 0).toUnixTimestamp());
        // addMatch("Macarthur vs. Truman", "Macarthur|Truman", 2, DateLib.DateTime(2018, 9, 3, 0, 0, 0, 0, 0).toUnixTimestamp());
        // addMatch("Macaque vs. Pregunto", "Macaque|Pregunto", 2, DateLib.DateTime(2018, 9, 21, 0, 0, 0, 0, 0).toUnixTimestamp());
        // addMatch("Farsworth vs. Wernstrom", "Farsworth|Wernstrom", 2, DateLib.DateTime(2018, 9, 29, 0, 0, 0, 0, 0).toUnixTimestamp());
        // addMatch("Fortinbras vs. Hamlet", "Fortinbras|Hamlet", 2, DateLib.DateTime(2018, 10, 10, 0, 0, 0, 0, 0).toUnixTimestamp());
        // addMatch("Foolicle vs. Pretendo", "Foolicle|Pretendo", 2, DateLib.DateTime(2018, 11, 11, 0, 0, 0, 0, 0).toUnixTimestamp());
        // addMatch("Parthian vs. Scythian", "Parthian|Scythian", 2, DateLib.DateTime(2018, 11, 12, 0, 0, 0, 0, 0).toUnixTimestamp());
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

    // string memory str = string(_bytes32);
    // TypeError: Explicit type conversion not allowed from "bytes32" to "string storage pointer"
    // thus we should fist convert bytes32 to bytes (to dynamically-sized byte array)

        // bytes memory bytesArray = new bytes(32);
        // for (uint256 i; i < 32; i++) {
        //     bytesArray[i] = _bytes32[i];
        // }
        bytes32 foo = _bytes32;
        string memory bar = string(abi.encodePacked(foo));
        return string(bar);
    }

}
