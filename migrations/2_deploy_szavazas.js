const Szavazas = artifacts.require("Szavazas");

module.exports = function (deployer) {
  deployer.deploy(Szavazas, "Kis Bela", "5.ker");
};
