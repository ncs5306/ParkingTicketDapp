pragma solidity ^0.8.11;

contract ParkingDapp{

    //struct holds parking ticket information
    struct Ticket{
        string firstName;
        string lastName;
        string email;
        string licencePlate;
        string stateRegisteredIn;
        address offenderAddress;
        uint fine;
        bool paid;
        bool added;
    }

    mapping(uint => Ticket) private TicketMap;
    address payable private owner;
    uint private fine;

    constructor(){
        //sets owner as contract deployer
        owner = payable(msg.sender);

        //sets the fine to 10 wei
        fine = 10;
    }

    //sets deployer as owner of the contract
    modifier _onlyOwner{
        require(msg.sender == owner);
        _;
    }


    //function to add ticket 
    function addTicket (
        uint _ticketNumber, 
        string memory _licencePlate, 
        string memory _stateRegisteredIn
        ) public _onlyOwner{

        TicketMap[_ticketNumber] = Ticket ({
            firstName: "N/A",
            lastName: "N/A",
            email: "N/A",
            licencePlate: _licencePlate,
            stateRegisteredIn: _stateRegisteredIn,
            offenderAddress: 0x0000000000000000000000000000000000000000,
            fine: fine,
            paid: false,
            added: true
        });

    }

    //function for user to pay ticket, must send exact value in wei
    function payTicket(
        uint _ticketNumber,
        string memory _firstName,
        string memory _lastName,
        string memory _email
    ) public payable{
        require(TicketMap[_ticketNumber].added == true, 
        "ticket with that number does not exist in our registry");

        require(TicketMap[_ticketNumber].paid == false,
        "ticket with that number has already been paid");

        require(msg.value == TicketMap[_ticketNumber].fine,
        "incorrect value sent");

        TicketMap[_ticketNumber].firstName = _firstName;
        TicketMap[_ticketNumber].lastName = _lastName;
        TicketMap[_ticketNumber].email = _email;
        TicketMap[_ticketNumber].offenderAddress = msg.sender;
        TicketMap[_ticketNumber].paid = true;
    }

    //allows owner to withdraw funds from the contract
    function transferFunds() public _onlyOwner{
        bool send = owner.send(address(this).balance);
        require(send, "Failed");
    }

    //allows owner to view any tickets in the database 
    function getTicket(uint _ticketNumber) public view _onlyOwner 
        returns(Ticket memory){

        //returns the ticket struct for that ticket number
        return TicketMap[_ticketNumber];
    }

    //admin can check the balance of the contract
    function checkBalance() public view _onlyOwner returns(uint){
        return address(this).balance;
    }



}
