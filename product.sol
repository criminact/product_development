pragma solidity ^0.5.16;

contract Product{
    
    address payable public owner;
    address payable public developer;
    uint256 public submission_date;
    string public specs;
    uint256 public budget;
    
    enum State {Ideation, Development, Testing, Analysis, Rollout, Inactive}
    
    State public state;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyDeveloper(){
        require(msg.sender == developer);  
        _;
    }
    
    modifier inState(State _state){
        require(state == _state);
        _;
    }
    
    constructor (string memory _specs) public payable {
        owner = msg.sender;
        specs = _specs;
        budget = msg.value;
        state = State.Ideation;
    }
    
    function developerBound(uint256 _completion_time) public inState(State.Ideation) {
        developer = msg.sender;
        submission_date =  _completion_time;
        state = State.Development;
    }
    
    function testingBound() public inState(State.Development) onlyDeveloper {
        if(now > submission_date){
            state = State.Inactive;
            owner.transfer(address(this).balance);
            return;   
        }
        
        state = State.Testing;
    }
    
    function analysisBound() public inState(State.Testing) onlyDeveloper {
        if(now > submission_date){
            state = State.Inactive;
            owner.transfer(address(this).balance);
            return;   
        }
        
        state = State.Analysis;
    }
    
    function rolloutBound() public inState(State.Rollout) onlyDeveloper {
        if(now > submission_date){
            state = State.Inactive;
            owner.transfer(address(this).balance);
            return;   
        }
        
        state = State.Rollout;
    }
    
    function ownerSatisfied(bool _satisfaction) public inState(State.Rollout) onlyOwner {
        if(_satisfaction == true){
            owner.transfer(budget);
            developer.transfer(address(this).balance);
            state = State.Inactive;
        }else{
            owner.transfer(address(this).balance);
            state = State.Inactive;
        }
    }

}
