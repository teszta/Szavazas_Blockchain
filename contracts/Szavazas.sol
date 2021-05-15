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

    mapping(uint => szavazas) private szavazatok;
    mapping(address => szavazo) public szavazokTomb;

    uint private osszes = 0;
    uint public eredmeny = 0;
    uint public osszesSzavazo = 0;
    uint public osszesSzavazat = 0;
    
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
    }

    modifier csakAdmin() {
        require(msg.sender == szavazasAdminAddress);
        _;
    }

    modifier StatuszEllenorzes(Statusz _statusz) {
        require(Szavazas_Statusz == _statusz);
        _;
    }

    event szavazoHozzaadva(address szavazo);
    event szavazasStart();
    event szavazasBefejezes(uint eredmeny);
    event szavazatLeadva(address szavazo);

    function UjSzavazo(address _szavazoAddress, string memory _szavazoNeve, string memory _kerulet) public StatuszEllenorzes(Statusz.Meghirdetve) csakAdmin {
        szavazo memory sz;
        sz.szavazoNeve = _szavazoNeve;
        sz.kerulet = _kerulet;
        sz.szavazott = false;
        szavazokTomb[_szavazoAddress] = sz;
        osszesSzavazo++;
        emit szavazoHozzaadva(_szavazoAddress);
    }

    function SzavazasKezdese() public StatuszEllenorzes(Statusz.Meghirdetve) csakAdmin {
        Szavazas_Statusz = Statusz.SzavazasAlatt;
        emit szavazasStart();
    }

    function szavazatLeadas(address _valasztott) public StatuszEllenorzes(Statusz.SzavazasAlatt) returns (bool szavazott) {
        bool talalat = false;
        if (bytes(szavazokTomb[msg.sender].szavazoNeve).length != 0 && !szavazokTomb[msg.sender].szavazott) {
            szavazokTomb[msg.sender].szavazott = true;
            szavazas memory sz;
            sz.szavazoAddress = msg.sender;
            sz.valasztott = true;
            if (sz.valasztott) {
                osszes++;
            }
            szavazatok[osszesSzavazat] = sz;
            osszesSzavazat++;
            talalat = true;
        }
        emit szavazatLeadva(msg.sender);
        return talalat;
    }

    function szavazasVege() public StatuszEllenorzes(Statusz.SzavazasAlatt) csakAdmin {
        Szavazas_Statusz = Statusz.Vege;
        eredmeny = osszes;
        emit szavazasBefejezes(eredmeny);
    }
    
}