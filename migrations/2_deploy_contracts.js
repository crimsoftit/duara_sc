const AssetManager = artifacts.require("AssetManager");
const Project = artifacts.require("Project");


module.exports = function (deployer) {
    deployer.deploy(AssetManager);
    deployer.deploy(Project);
};
