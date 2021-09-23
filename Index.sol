pragma solidity 0.8.7;
pragma abicoder v2;


contract Wallet {
    // Tableau des owners
    address[] public owners; 
    uint limit;

// Struct d'un transfert 

    struct Transfer{
        uint id;
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
         
    }




}