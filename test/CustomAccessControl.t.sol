import {CustomAccessControl} from "src/CustomAccessControl.sol";
import {Test, console2} from "forge-std/Test.sol";

contract TestAccessControl is Test {
    CustomAccessControl accessControl;
    address minter = address(0x1);
    address minterAdmin = address(0x2);
    address burner = address(0x3);
    address burnerAdmin = address(0x4);
    address defaultAdmin = address(0x5);
    address alice = address(0x6);
    address bob = address(0x7);
    bytes32 public constant MINTER_ADMIN = keccak256("MINTER_ADMIN");
    bytes32 public constant MINTER = keccak256("MINTER");
    bytes32 public constant BURNER_ADMIN = keccak256("BURNER_ADMIN");
    bytes32 public constant BURNER = keccak256("BURNER");
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;


    function setUp() public {
        accessControl = new CustomAccessControl(minter, minterAdmin, burner, burnerAdmin, defaultAdmin);
    }

    function testSetup() public {
        assertEq(accessControl.hasRole(MINTER, minter), true);
        assertEq(accessControl.hasRole(MINTER_ADMIN, minterAdmin), true);
        assertEq(accessControl.hasRole(BURNER, burner), true);
        assertEq(accessControl.hasRole(BURNER_ADMIN, burnerAdmin), true);
    }

    /**
      User with admin role can grant and revoke role
    */
    function testOnlyAdminRoleCanGrantAndRevoke() public {
        // Minter Admin can grant/revoke minter role
        vm.prank(minterAdmin);
        accessControl.grantRole(MINTER, alice);
        // assert that alice has been granted minter role
        assertEq(accessControl.hasRole(MINTER, alice), true);
        // Now alice can call mint function
        vm.prank(alice);
        accessControl.mint(alice, 1e18);
        assertEq(accessControl.balances(alice), 1e18);

        // Bob can't call mint because he has no minter role
        assertEq(accessControl.hasRole(MINTER, bob), false);
        vm.startPrank(bob);
        vm.expectRevert();
        accessControl.mint(bob, 1e18);
        // Bob can't grant/revoke minter role since he
        // doesnt has role MINTER_ADMIN
        vm.expectRevert();
        accessControl.grantRole(MINTER, bob);
        vm.stopPrank();
    }

    /**
        Default admin (0x00) is the default admin role for all roles
    */
    function testDefaultAdminRole() public{
        // Default admin is the default admin role for any role
        bytes32 ANY_ROLE = keccak256("ANY_ROLE");
        assertEq(accessControl.getRoleAdmin(ANY_ROLE), DEFAULT_ADMIN_ROLE);

        vm.prank(defaultAdmin);
        accessControl.grantRole(ANY_ROLE, bob);
        assertEq(accessControl.hasRole(ANY_ROLE, bob), true);
    }

    /**
        A user can renounce his/her own role
    */
    function testRenounceRole() public {
        // Minter renounce his/her role
        vm.prank(minter);
        accessControl.renounceRole(MINTER, minter);
        assertEq(accessControl.hasRole(MINTER, minter), false);

    }
}