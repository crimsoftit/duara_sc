const DateLib = artifacts.require("DateLib");
const Ownable = artifacts.require("Ownable");

module.exports = function (deployer) {
    deployer.deploy(DateLib);
    deployer.deploy(Ownable);
};
