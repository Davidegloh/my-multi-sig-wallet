pragma solidity 0.8.7;
pragma abicoder v2;


contract Wallet {
    //Events
    event setApprovals(address indexed owner, uint txIndex);

    // Array of owners of the contract
    address[] public owners; 
    // state variable of the limit of approvals
    uint limit;

// Struct of a transaction 

    struct Transfer{
        uint id;
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
         
    }

// Array of transfer requests
Transfer[] transferRequests;

// Mapping approvals
mapping(address => mapping(uint => bool)) approvals;
// Mapping isOwner
mapping(address => bool) public isOwner;

// Modifiers
//Should only allow people in the owners list to continue the execution.
    modifier onlyOwners(){
        bool owner = false;
        for(i=0; i<owners.length; i++){
            if (owners[i] == msg.sender){
                owner = true;
            }
            require (owner = true);
            _;
        }
        


    //Should initialize the owners list and the limit 
    constructor(address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit; 
        require(_limit > 0 && _limit <= _owners.length,"number of limit of approval is invalid");
        require(owners.length > 0, "owner required");

    }

    //Empty deposit function
    function deposit() public payable {}

    //Create an instance of the Transfer struct and add it to the transferRequests array
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners { // I create the function "createTransfer" with 2 inputs (amount and receiver)
        transferRequests.push(// I add the Transfer instance to the transferRequests array
        Transfer(_amount, _receiver, 0, false, transferRequests.length) //I create an instance of Transfer with the proper properties of a Transaction.
        );
    }

    
    //Need to update the mapping to record the approval for the msg.sender.
    //When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
    //Set your approval for one of the transfer requests
    function setApproval(uint _id) public onlyOwner {
        Transfer storage transfer =  transferRequests[_id]; // it allows to update the transaction struct and to assign the value passed input to the storage variable transaction
        require(approvals[msg.sender][_id] == false);//An owner should not be able to vote twice.
        require(transferRequests[_id].hasBeenSent == false);//An owner should not be able to vote on a tranfer request that has already been sent.

        approvals[msg.sender][_id] == true;
        transferRequests[_id].approvals++;

        if(transferRequests[_id].approvals >=limit){
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
        }
   
    }

//Should reuturn all transfer requests
function getTransfertRequests() public view returns(Transfer[]memory){
    return transferRequests;
}


}
