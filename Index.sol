pragma solidity 0.8.7;
pragma abicoder v2; //allows to return a struct (line 87)


contract Wallet {
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

//Events
    event TransferRequestCreated(uint _id, uint amount, address initiator, address _receiver);
    event ApprovalReceived(uint _id, uint approvals, address approver);
    event TransferApproved(uint _id);

// Array of transfer requests
Transfer[] transferRequests;

// Mapping approvals
mapping(address => mapping(uint => bool)) approvals;
// Mapping isOwner
mapping(address => bool) public isOwner;
//Mapping balance
mapping(address => uint) balance;

// Modifiers
//Should only allow people in the owners list to continue the execution.
    modifier onlyOwners(){
        bool owner = false;
        for(i=0; i<owners.length; i++){
            if (owners[i] == msg.sender){
                owner = true;
            }

        }
        require (owner = true);
        _;
    }
        


    //Should initialize the owners list and the limit. Constructor is used to initialize state variables of a contract.
    constructor(address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit; 
        require(_limit > 0 && _limit <= _owners.length,"number of limit of approval is invalid");
        require(owners.length > 0, "owner required");

    }

    //Empty deposit function
    function deposit() public payable {}

    // Function getBalance
    function getBalance() public view returns(uint) {
    return address(this).balance;

    }

    //Create an instance of the Transfer struct and add it to the transferRequests array. I use it when an owner wants to initiate a transfer
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners { // I create the function "createTransfer" with 2 inputs (amount and receiver)
        emit TransferRequestCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(// I add the Transfer instance to the transferRequests array
        Transfer(0, _amount, _receiver,transferRequests.length,false) //I create an instance of Transfer with the proper properties of a Transaction.
        );
    }

    
    //Need to update the mapping to record the approval for the msg.sender.
    //When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
    //Set your approval for one of the transfer requests
    //An owner should not be able to vote twice.
    //An owner should not be able to vote on a tranfer request that has already been sent.
    function Approve(uint _id) public onlyOwners {
        require(approvals[msg.sender][_id] == false);//An owner should not be able to vote twice.
        require(transferRequests[_id].hasBeenSent == false);//An owner should not be able to vote on a tranfer request that has already been sent.

        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++; ////Need to update the mapping to record the approval for the msg.sender.

        emit ApprovalReceived(_id,transferRequests[_id].approvals, msg.sender);

        if(transferRequests[_id].approvals >=limit){ // //When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
            emit TransferApproved(_id);
        }
   
    }

//Should return all transfer requests
function getTransfertRequests() public view returns(Transfer[]memory){
    return transferRequests;
}


}
