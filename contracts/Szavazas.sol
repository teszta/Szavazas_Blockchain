pragma solidity ^0.5.0;

contract Szavazas {

    struct szavazas {
        address szavazoAddress;
        string kerulet;
        bool valasztott;
    }

    struct szavazo {
        string szavazoNeve;
        string kerulet;
        bool szavazott;
    }

    struct indulok {
        string induloNeve;
        uint kapottSzavazat;
        string kerulet;
    }

    mapping(uint => szavazas) private szavazatok;
    mapping(address => szavazo) public szavazokTomb;
    mapping(address => indulok) public indulokTomb;

    uint private osszes = 0;
    uint public eredmeny;
    uint public osszesIndulo;
    uint public osszesSzavazo;
    uint public osszesSzavazat;
    
    address public szavazasAdminAddress;
    string public szavazasAdminNeve;
    string public szavazoKerulet;

    enum Statusz { Meghirdetve, SzavazasAlatt, Vege }
    Statusz public Szavazas_Statusz;

    constructor(string memory _szavazasAdminNeve,string memory _szavazoKerulet) public {
        szavazasAdminAddress = msg.sender;
        szavazasAdminNeve = _szavazasAdminNeve;
        szavazoKerulet = _szavazoKerulet;
        Szavazas_Statusz = Statusz.Meghirdetve;
        eredmeny = 0;
        osszesIndulo = 0;
        osszesSzavazo = 0;
        osszesSzavazat = 0;
    }

    modifier csakAdmin() {
        require(msg.sender == szavazasAdminAddress);
        _;
    }

    modifier StatuszEllenorzes(Statusz _statusz) {
        require(Szavazas_Statusz == _statusz);
        _;
    }

    modifier KeruletEllenorzes(string memory _kerulet) {
        require(compareStrings(_kerulet, szavazoKerulet));
        _;
    }

    event szavazoHozzaadva(address szavazo);
    event szavazasStart();
    event szavazasBefejezes(uint eredmeny);
    event szavazatLeadva(address szavazo);
    event szavazasUjraindul();
    event induloHozzaadva(address indulo);

    function compareStrings(string memory a, string memory b) public view returns (bool) {
        return (keccak256(bytes(a)) == keccak256(bytes(b)));
    }

    function UjSzavazo(address _szavazoAddress, string memory _szavazoNeve, string memory _kerulet) public StatuszEllenorzes(Statusz.Meghirdetve) csakAdmin {
        szavazo memory sz;
        sz.szavazoNeve = _szavazoNeve;
        sz.kerulet = _kerulet;
        sz.szavazott = false;
        szavazokTomb[_szavazoAddress] = sz;
        osszesSzavazo++;
        emit szavazoHozzaadva(_szavazoAddress);
    }

    function UjIndulo(address _induloAddress, string memory _induloNeve, string memory _kerulet) public StatuszEllenorzes(Statusz.Meghirdetve) {
        indulok memory i;
        i.induloNeve = _induloNeve;
        i.kerulet = _kerulet;
        i.kapottSzavazat = 0;
        indulokTomb[_induloAddress] = i;
        osszesIndulo++;
        emit induloHozzaadva(_induloAddress);
    }

    function SzavazasKezdese() public StatuszEllenorzes(Statusz.Meghirdetve) csakAdmin {
        Szavazas_Statusz = Statusz.SzavazasAlatt;
        emit szavazasStart();
    }

    function szavazatLeadas(address _valasztott) public StatuszEllenorzes(Statusz.SzavazasAlatt) KeruletEllenorzes(szavazokTomb[msg.sender].kerulet) returns (bool szavazott) {
        bool talalat = false;
        if (bytes(szavazokTomb[msg.sender].szavazoNeve).length != 0 && !szavazokTomb[msg.sender].szavazott) {
            if(bytes(indulokTomb[_valasztott].induloNeve).length != 0) {
                indulokTomb[_valasztott].kapottSzavazat++;
                szavazokTomb[msg.sender].szavazott = true;
                szavazas memory sz;
                sz.szavazoAddress = msg.sender;
                sz.valasztott = true;
                osszes++;
                szavazatok[osszesSzavazat] = sz;
                osszesSzavazat++;
                talalat = true;  
            } 
        }
        emit szavazatLeadva(msg.sender);
        return talalat;
    }

    function szavazasVege() public StatuszEllenorzes(Statusz.SzavazasAlatt) csakAdmin {
        Szavazas_Statusz = Statusz.Vege;
        eredmeny = osszes;
        emit szavazasBefejezes(eredmeny);
    }

    function szavazasReset() public StatuszEllenorzes(Statusz.Vege) csakAdmin {
        Szavazas_Statusz = Statusz.Meghirdetve;
        osszes = 0;
        eredmeny = 0;
        osszesSzavazo = 0;
        osszesSzavazat = 0;
        emit szavazasUjraindul();
    }
    
}