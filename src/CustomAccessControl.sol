import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract CustomAccessControl is AccessControl {
    mapping(address => uint256) public balances;
    bytes32 public constant MINTER_ADMIN = keccak256("MINTER_ADMIN");
    bytes32 public constant MINTER = keccak256("MINTER");

    bytes32 public constant BURNER_ADMIN = keccak256("BURNER_ADMIN");
    bytes32 public constant BURNER = keccak256("BURNER");


    constructor(address minter, address minterAdmin, address burner, address burnerAdmin,
        address defaultAdmin) public {
        _setRoleAdmin(MINTER, MINTER_ADMIN);
        _setRoleAdmin(BURNER, BURNER_ADMIN);
        _grantRole(MINTER, minter);
        _grantRole(MINTER_ADMIN, minterAdmin);
        _grantRole(BURNER, burner);
        _grantRole(BURNER_ADMIN, burnerAdmin);

        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
    }
    function mint(address _account, uint256 _amount) public onlyRole(MINTER) {
        balances[_account] += _amount;
    }
    function burn(address _account, uint256 _amount) public onlyRole(BURNER) {
        balances[_account] -= _amount;
    }


}

