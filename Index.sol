pragma solidity 0.8.7;
pragma abicoder v2;


contract Wallet {
    //Events
    event setApprovals(address indexed owner, uint txIndex);

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
        require (isOwner[msg.sender], "not owner");
        _;
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

    //Set your approval for one of the transfer requests.
    function setApproval(uint _id) public onlyOwner {
        Transfer storage transfer =  transferRequests[_id]; // it allows to update the transaction struct and to assign the value passed input to the storage variable transaction
        transfer.approvals += 1; 
        approvals[msg.sender][_id] = true; 
        emit setApprovals(msg.sender, _id);
    }
   //Need to update the Transfer object
    //Need to update the mapping to record the approval for the msg.sender.
    //When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
    //An owner should not be able to vote twice.
    //An owner should not be able to vote on a tranfer request that has already been sent.

}
