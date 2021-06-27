pragma solidity >=0.4.22 <0.9.0;


contract UserCrud {

    struct UserStruct {
        string userEmail;
        uint userAge;
        uint index;
    }
  
    mapping(address => UserStruct) private userStructs;
    address[] private userIndex;

    event LogNewUser(address indexed userAddress, uint index, string userEmail, uint userAge);
    event LogUpdateUser(address indexed userAddress, uint index, string userEmail, uint userAge);
    event LogDeleteUser(address indexed userAddress, uint index);
  
    function isUser(address userAddress) public view returns(bool isIndeed) {
        if (userIndex.length == 0) return false;
        return (userIndex[userStructs[userAddress].index] == userAddress);
    }

    function insertUser(address userAddress, string memory userEmail, uint userAge) public returns(uint index) {
        if (isUser(userAddress)) revert();

        userStructs[userAddress].userEmail = userEmail;
        userStructs[userAddress].userAge = userAge;
        userStructs[userAddress].index = userIndex.push(userAddress)-1;
        
        emit LogNewUser (userAddress, userStructs[userAddress].index, userEmail, userAge);
        return userIndex.length-1;
    }

    function deleteUser(address userAddress) public returns(uint index) {
        if (!isUser(userAddress)) revert(); 
        uint rowToDelete = userStructs[userAddress].index;
        address keyToMove = userIndex[userIndex.length-1];
        userIndex[rowToDelete] = keyToMove;
        userStructs[keyToMove].index = rowToDelete; 
        userIndex.length--;
        emit LogDeleteUser (userAddress, rowToDelete);
        emit LogUpdateUser (keyToMove, rowToDelete, userStructs[keyToMove].userEmail, userStructs[keyToMove].userAge);
        return rowToDelete;
    }
  
    function getUser(address userAddress) public view returns(string memory userEmail, uint userAge, uint index) {
        if (!isUser(userAddress)) revert (); 
        return(
            userStructs[userAddress].userEmail, 
            userStructs[userAddress].userAge, 
            userStructs[userAddress].index);
    } 
  
    function updateUserEmail(address userAddress, string memory userEmail) public returns(bool success) {
        if (!isUser(userAddress)) revert(); 
        userStructs[userAddress].userEmail = userEmail;
        emit LogUpdateUser(userAddress, userStructs[userAddress].index, userEmail, 
            userStructs[userAddress].userAge);
        return true;
    }
  
    function updateUserAge(address userAddress, uint userAge) public returns(bool success) {
        if (!isUser(userAddress)) revert(); 
        userStructs[userAddress].userAge = userAge;
        emit LogUpdateUser (userAddress, userStructs[userAddress].index, userStructs[userAddress].userEmail, userAge);
        return true;
    }

    function getUserCount() public view returns(uint count) {
        return userIndex.length;
    }

    function getUserAtIndex(uint index) public view returns(address userAddress) {
        return userIndex[index];
    }

}
