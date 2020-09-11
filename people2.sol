pragma solidity 0.5;

contract HelloWorld{
   
   struct Person {
       uint id;
       string name;
       uint age;
       uint height;
       bool senior;
   }
   
   
   Person[] private people;
   
   mapping(address => uint[]) private peopleIds;
   
   function addPeople(Person memory newPerson) private {
       uint index = people.length;
       people.push(newPerson); 
       peopleIds[msg.sender].push(index);
   }
   
   function peopleFromAddress() public view returns(uint[] memory ids){
       return peopleIds[msg.sender];
   }
    
  
   function createPerson(string memory name, uint age, uint height) public {
       uint index = people.length;
       Person memory newPerson;
       newPerson.name = name;
       newPerson.age = age;
       newPerson.id = index;
       newPerson.height = height;
       addPeople(newPerson);
       
   }
   
   function getPerson(uint index) public view returns(uint id, string memory name, uint age, uint height){
       return (people[index].id, people[index].name, people[index].age, people[index].height);
   }
   
   
   
}