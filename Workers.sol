import "./InheritanceAssignment.sol";
pragma solidity 0.5.12;


contract Workers is People {
    
    mapping(address => uint) public salary;
    
    function createWorker(string memory name, uint age, uint height, uint _salary) public payable {
        address worker = msg.sender;
        salary[worker] = _salary;
        People.createPerson(name, age, height);
    }
    
    
}