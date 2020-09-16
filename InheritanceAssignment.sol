import "./Ownable.sol";
pragma solidity 0.7.0;


contract People {
    
   struct Person {
       uint id;
       string name;
       uint age;
       uint height;
       bool senior;
   }
   
   event personCreated(string name, bool senir); // define the event. To emit the event can happen whereever needed
   event personDeleted(string name, bool senior, address deletedBy);
   

   uint public balance;
   
   
   
   modifier costs(uint cost){
       require(msg.value >= cost);
       _;
   }
   
   
   mapping(address => Person) private people;  
   
   address[] private creators;
   
   function createPerson(string memory name, uint age, uint height) internal costs(100 wei) {
       require(age <= 150, "Age needs to be below 150");
       // check if payment is >= 1, if lower fct won't execute
       // balance += msg.value; // could also be written as: balance = balance + msg.sender;
       
        //This creates a person
        Person memory newPerson;
         newPerson.name = name;
         newPerson.age = age;
         newPerson.height = height;
         newPerson.senior = false;
         if(age >= 65){
             newPerson.senior = true;
         }
         else{
             newPerson.senior = false;
         }
        insertPerson(newPerson);
        creators.push(msg.sender);
        //the below is an assert function that checka if: people[msg.sender] == new Person;
        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name, 
                    people[msg.sender].age, 
                    people[msg.sender].height, 
                    people[msg.sender].senior
                )
            )
            == 
            keccak256(
                abi.encodePacked(
                    newPerson.name, 
                    newPerson.age, 
                    newPerson.height, 
                    newPerson.senior
                )
            )
        );
        
        emit personCreated(newPerson.name, newPerson.senior); // this is sending the event
    }
    
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
         people[creator] = newPerson;
    }
    
    function getPerson() public view returns(string memory name, uint age, uint height, bool senior){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
    
    function deletePerson(address creator) public onlyOwner {
        string memory name = people[creator].name;
        bool senior = people[creator].senior;
        delete people[creator];
        // people [creator].age == 0; which basically means that after having deleted this person, the age should return 0, 
        //because the mapping is now empty
        assert(people[creator].age == 0);
        emit personDeleted(name, senior, msg.sender); // we had to save the data locally first (see line below funciton deletePerson) 
        // because using deletePerson has removed the data!
        
    }
    
    function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
    
    function withdrawAll() public onlyOwner returns(uint){
        uint toTransfer = balance;
        balance = 0; 
        msg.sender.transfer(toTransfer); // can use "send" instead of "transfer". "send" will return "false" but not revert!!!
        // it will not execute the transfer, but reset the balance to 0 which would be disastrous. So why does it even exist?
        // so using "send" we need to handle the errors ourselves, so "send is preferable if you need custom error handling."
        return toTransfer;
    }
    }