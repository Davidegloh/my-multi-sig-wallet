pragma solidity 0.8.7;
pragma abicoder v2;


contract Wallet {
    // Tableau des owners
    address[] public owners; 
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




}
