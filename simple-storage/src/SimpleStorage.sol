// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

 contract SimpleStorage {

    uint public favoriteNumber;
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    function retrievebyName(string memory _name) public view returns (uint256) {
        require(listOfPeople.length > 0, "No people added yet");
        return nameToFavoriteNumber[_name]; // Returning the favorite number associated with the name
    }

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
}