// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Project
{
    struct Person {
        string name;
        uint funds;
    }

    // this is the mapping for which we want the compiler to automatically generate a getter.
    mapping(address => Person) public people;

    mapping(string => address) getAddressFromName;

    function addPerson (string memory _name, uint _funds) public {
        Person memory newPerson = Person(_name, _funds);
        people[msg.sender] = newPerson;
        getAddressFromName[_name] = msg.sender;
    }

    function getPersonByName(string memory _name) public view returns(address){
        return getAddressFromName[_name];
    }

    function addTestData () public {
        addPerson("Ëmmanuel", 20000);
        addPerson("Billy", 30000);
        addPerson("Ëugene", 40000);
    }
}
