const AssetManager = artifacts.require("AssetManager");
const Project = artifacts.require("Project");
const ProjectFunding = artifacts.require("ProjectFunding");


module.exports = function (deployer) {
    deployer.deploy(AssetManager);
    deployer.deploy(Project);
    deployer.deploy(ProjectFunding);
};
