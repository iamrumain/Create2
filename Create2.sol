// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Create2Factory {

    event ContractDeployed(address addr, uint256 salt);

    function deploy(bytes memory bytecode, uint256 salt) public returns (address) {
        address addr;
        require(bytecode.length != 0, "Bytecode cannot be empty");

        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }

        require(addr != address(0), "CREATE2 failed");
        emit ContractDeployed(addr, salt);
        return addr;
    }

    function computeAddress(bytes memory bytecode, uint256 salt) public view returns (address) {
        bytes32 hash = keccak256(bytecode);
        bytes32 data = keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            hash
        ));
        return address(uint160(uint256(data)));
    }
}
