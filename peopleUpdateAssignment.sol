pragma solidity 0.7.0;

contract HelloWorld{
    
   
   struct Person {
       uint id;
       string name;
       uint age;
       uint height;
       address walletAddress;
   }
   
   event personCreated(string name, uint age, uint height, address walletAddress); // define the event. To emit the event see end of function createPerson
   event personDeleted(string name, address deletedBy);
   event personUpdated(string oldName, uint oldAge, uint oldHeight, address oldWalletAddress, string name, uint age, uint height, address walletAddress);    
   
   address public owner;
   
   modifier onlyOwner(){
       require(msg.sender == owner);
       _; //once solidity reaches _; it knows it can continue (modifier complete)
   }
   
   modifier peopleEmpty(){
       bool isEmpty;
       if(people[msg.sender].age != 0 || people[msg.sender].height != 0){
       isEmpty = false;
       } 
       else{
       isEmpty = true;
       }
       require(isEmpty == false, "Person doesn't exist");
       require(bytes (people[msg.sender].name).length != 0, "No string available");
       _;
       
   }
       
   
   
   constructor() public {
       owner = msg.sender;
   }
   
   mapping(address => Person) private people;  
   
   address[] private creators;
   
   
   function createPerson(string memory name, uint age, uint height) public {
       require(age <= 150, "Age needs to be below 150");
       //if (address[msg.sender] > 0 ){
         //  update();
      //} else {}

        //This creates a person
        Person memory newPerson;
         newPerson.name = name;
         newPerson.age = age;
         newPerson.height = height;
         newPerson.walletAddress = msg.sender;
        insertPerson(newPerson);
        creators.push(msg.sender);
        //the below is an assert function that checks if: people[msg.sender] == new Person;
        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name, 
                    people[msg.sender].age, 
                    people[msg.sender].height, 
                    people[msg.sender].walletAddress
                )
            )
            == 
            keccak256(
                abi.encodePacked(
                    newPerson.name, 
                    newPerson.age, 
                    newPerson.height, 
                    newPerson.walletAddress
                )
            )
        );
        
        emit personCreated(newPerson.name, newPerson.age, newPerson.height,newPerson.walletAddress); // this is sending the event
    }

    
    function updatePerson(string memory name, uint age, uint height) public peopleEmpty() {
        string memory oldName = people[msg.sender].name;
        uint oldAge = people[msg.sender].age;
        uint oldHeight = people[msg.sender].height;
        address oldWalletAddress = people[msg.sender].walletAddress;
        
        Person memory updatedPerson;
         updatedPerson.name = name;
         updatedPerson.age = age;
         updatedPerson.height = height;
         updatedPerson.walletAddress = msg.sender;
        
         insertPerson(updatedPerson);
    
        assert(
            keccak256(
                abi.encodePacked(
                    oldName, oldAge, oldHeight, oldWalletAddress
                )
            )
            != 
            keccak256(
                abi.encodePacked(
                    updatedPerson.name, 
                    updatedPerson.age, 
                    updatedPerson.height, 
                    updatedPerson.walletAddress
                )
            )
        );
        
        emit personUpdated(
            oldName, oldAge, oldHeight, oldWalletAddress, 
            updatedPerson.name, updatedPerson.age, updatedPerson.height, updatedPerson.walletAddress);
  
        
    }
    
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
         people[creator] = newPerson;
    }
    
    function getPerson() public view returns(string memory name, uint age, uint height, address walletAddress){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].walletAddress);
    }
    
    function deletePerson(address creator) public onlyOwner {
        string memory name = people[creator].name;
        delete people[creator];
        // people [creator].age == 0; which basically means that after having deleted this person, the age should return 0, 
        //because the mapping is now empty
        assert(people[creator].age == 0);
        emit personDeleted(name, msg.sender); // we had to save the data locally first (see line below funciton deletePerson) 
        // because using deletePerson has removed the data!
        
    }
    
    function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
}