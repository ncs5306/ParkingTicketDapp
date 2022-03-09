pragma solidity ^0.8.11;

contract ParkingDapp{

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

    modifier _onlyOwner{
        require(msg.sender == owner);
        _;
    }


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

    function transferFunds() public _onlyOwner{
        bool send = owner.send(address(this).balance);
        require(send, "Failed");
    }


    function getTicket(uint _ticketNumber) public view _onlyOwner 
        returns(Ticket memory){

        //returns the ticket struct for that ticket number
        return TicketMap[_ticketNumber];
    }

    function checkBalance() public view returns(uint){
        return address(this).balance;
    }



}
