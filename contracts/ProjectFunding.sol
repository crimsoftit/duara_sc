// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ProjectFunding
{
    struct Person {
        string name;
        uint256 funds;
    }

    // this is the mapping for which we want the compiler to automatically generate a getter.
    mapping(uint256 => Person) public people;

    mapping(string => uint256) getFundsFromName;

    function addPerson (string memory _name, uint256 _funds) public {
        Person memory newPerson = Person(_name, _funds);
        people[_funds] = newPerson;
        getFundsFromName[_name] = _funds;
    }

    function getPersonByName(string memory _name) public view returns(uint256){
        return getFundsFromName[_name];
    }

    function addTestData () public {
        addPerson("Ëmmanuel", 20000);
        addPerson("Billy", 30000);
        addPerson("Ëugene", 40000);
    }
}
