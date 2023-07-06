# A simple explanation of Openzeppelin AccessControl contract with foundry test

## About OpenZeppelin Access Control
AccessControl module, by Openzeppelin document ` allows children to implement role-based access control mechanisms`
Role-based Access Control is basically when you have multiple roles, each role is associated with one
or more privileges, and users are assigned one or multiple roles.

Openzeppelin's AccessControl contract could be summary as follows:
-   Each role is referred by a `bytes32` identifier, for example:
    `bytes32 public constant BURNER = keccak256("BURNER");`
-   Each role is associated with an `admin role`, only users with this `admin role` can grant/revoke
    that role. For example, if there is a role called `Manager` having `Manager admin` as its admin role. Only
    users with `Manager admin` can grant/revoke `Manager` role.
-   A user could be assigned multiple roles
-   A user can renounce (remove) his/her own role
-   There's a special role called `default admin role`, identified as `0x00` (`bytes32` with all 0 bytes).
    This role is the default `admin role` of all roles. This happens because the default value of `adminRole` in
    `RoleData` struct is `0x00`:
    ```solidity
        struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }
    ```
    
## Access Control core functions:
-   `hasRole(bytes32 role, address account)`: Check if `account` is assigned `role`
-   `onlyRole(bytes32 role)`: This is a modifier for checking of `msg.sender` is assigned `role`
-   `grantRole(bytes32 role, address account)`: Grant `account` the role `role`
-   `revokeRole(bytes32 role, address account)`: Revoke `account` the role `role`
-   `renounceRole(bytes32 role, address account)`: Used if someone want to renounce their own roles
-   `_setRoleAdmin(bytes32 role, bytes32 adminRole)`: Internal functions to set a role's admin role
## Run test
-   Clone git project:<br>
`git clone https://github.com/ktg9/OpenZeppelin-AccessControll-Explain.git`
-   Run tests:<br>
`forge test -vvvv`

# Reference
https://docs.openzeppelin.com/contracts/4.x/api/access#AccessControl