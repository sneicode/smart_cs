pragma solidity 0.5; 
pragma experimental ABIEncoderV2;

contract HelloWorldArray {
    
    struct Person {
       uint id;
       string name;
       uint age;
       uint height;
       address walletAddress;
   }
   
   Person[] public people;
   
   //When someone creates a new person, add the Person object to the people array instead of the mapping.
   //Then modify the Person struct and add an address property Creator. Make sure to edit the createPerson function 
  //so that it sets this property to the msg.sender.
   function createPerson(string memory name, uint age, uint height) public {
       Person memory newPerson;
       newPerson.id = people.length;
       newPerson.name = name;
       newPerson.age = age;
       newPerson.height = height;
       newPerson.walletAddress = msg.sender;
       people.push(newPerson);
    
   }
   
   //Create a public get function where we can input an index and retrieve the Person object with that index in the array.
   //The get function is already created automatically by solidity as the function is public. Create all the same:
    function getPerson(uint index) public view returns(Person memory) {
    return people[index];
    //return (people[index].name, people[index].age, people[index].height, people[index].walletAddress);
  //(string memory name, uint age, uint height, address walletAddress)
  
}
    
    
}