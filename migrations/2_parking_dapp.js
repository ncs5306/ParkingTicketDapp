const ParkingDapp = artifacts.require("ParkingDapp");

module.exports = function (deployer) {
  deployer.deploy(ParkingDapp);
};