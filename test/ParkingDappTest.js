const ParkingDapp = artifacts.require("ParkingDapp");

contract("ParkingDapp", accounts => {
    it("Checks if admin can add parking ticket", async () => {
        let parkingDapp = await ParkingDapp.deployed();
        await parkingDapp.addTicket(1,"T76LMX", "New York");
        let test = await parkingDapp.getTicket(1);
        //assert.equals(test, )

        console.log(test.toString());
    
        
    });
    it("Checks if user can pay ticket", async () => {
        let parkingDapp = await ParkingDapp.deployed();
        await parkingDapp.payTicket(1,"nick", "Saros", "ncs5306@psu.edu", {value: 10});
        let balance = await parkingDapp.checkBalance();
        assert.equal(balance, 10);
        

    });
    it("checks if withdraw function works", async () => {
        let parkingDapp = await ParkingDapp.deployed();
        await parkingDapp.transferFunds();
        let balance = await parkingDapp.checkBalance();
        assert.equal(balance, 0);
    });
    
});