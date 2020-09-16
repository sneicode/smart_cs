pragma solidity 0.5.12;
contract MemoryAndStorage{
    
    mapping(address => User) users;
    
    struct User{
        uint num;
        uint balance;
    }
    
    function addUser(uint num, uint balance) public {
        users[msg.sender] = User(num, balance);
    } 
     
    function updateBalance(uint balance) public {
        users[msg.sender].balance = balance;
    }
     
    function getBalance() view public returns(uint) {
        return users[msg.sender].balance;
    }
    
    
}