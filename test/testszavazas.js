const Szavazas = artifacts.require("Szavazas");
var SzavazasInstance;
var message;

contract('Szavazas', function(accounts) {
    it('1. Eredmeny teszt', function() {
        return Szavazas.deployed().then(function(instance) {
            SzavazasInstance = instance;
            return SzavazasInstance.eredmeny();             
        }).then(function(result) {
            assert.equal(result, 0, "Eredmeny valtozo inicializalva lett");            
        });
    });
    it('2. Indulo teszt', function() {
        return Szavazas.deployed().then(function(instance) {
            SzavazasInstance = instance;
            return SzavazasInstance.osszesIndulo();             
        }).then(function(result) {
            assert.equal(result, 0, "Indulo valtozo inicializalva lett");            
        });
    });
    it('3. Szavazo teszt', function() {
        return Szavazas.deployed().then(function(instance) {
            SzavazasInstance = instance;
            return SzavazasInstance.osszesSzavazo();             
        }).then(function(result) {
            assert.equal(result, 0, "Szavazo valtozo inicializalva lett");            
        });
    });
    it('4. Szavazat teszt', function() {
        return Szavazas.deployed().then(function(instance) {
            SzavazasInstance = instance;
            return SzavazasInstance.osszesSzavazat();             
        }).then(function(result) {
            assert.equal(result, 0, "Szavazat valtozo inicializalva lett");            
        });
    });
    it('5. Uj indulo teszt', function() {
        return Szavazas.deployed().then(function(instance) {
            SzavazasInstance = instance;
            return SzavazasInstance.UjIndulo(accounts[0],"Nagy Bandi", "6.ker");             
        }).then(function(result) {
            assert.throws(() => truffleAssert.eventEmitted(result, 'induloHozzaadva'));          
        });
    });
    it('6. Uj szavazo teszt', function() {
        return Szavazas.deployed().then(function(instance) {
            SzavazasInstance = instance;
            return SzavazasInstance.UjSzavazo(accounts[0],"Kis Bela", "1.ker");             
        }).then(function(result) {
            assert.throws(() => truffleAssert.eventEmitted(result, 'szavazoHozzaadva'));          
        });
    });
});