pragma solidity 0.8.7;
pragma abicoder v2;


contract Wallet {
    // Tableau des owners du contrat 
    address[] public owners; 
    // state variable of the limit of approvals
    uint limit;

// Struct d'une transaction 

    struct Transfer{
        uint id;
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
         
    }

// Tableau des demandes de transfert
Transfer[] transferRequests;

// Mapping approvals
mapping(address => mapping(uint => bool)) approvals;
mapping(address => bool) public isOwner;

// Modifiers

//Should only allow people in the owners list to continue the execution.
    modifier onlyOwners(){
        require (isOwner[msg.sender] "not owner");
    }

    //Should initialize the owners list and the limit 
    constructor(address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit; 
        require(_limit > 0 && _limit <= _owners.length,"number of limit of approval is invalid");
        require(owners.length > 0, "owner required");

    }

    //Empty function
    function deposit() public payable {}

}
