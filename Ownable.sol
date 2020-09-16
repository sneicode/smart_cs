pragma solidity 0.7.0.;

contract Ownable{
    
        address internal owner;

        modifier onlyOwner(){
            require(msg.sender == owner);
            _; //once solidity reaches _; it knows it can continue (modifier complete) - the "_; is actually where solidity
            // pastes the function that calls the modifier, so the modifier will be inside the scope of the fct"
        }
        
        constructor() public {
        owner = msg.sender;
        }
    }