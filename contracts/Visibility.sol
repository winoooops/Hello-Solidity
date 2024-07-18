// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Base {
	function publicFunc() public pure returns (string memory) {
		return "This is public";
	}
	
	function privateFunc() private pure returns (string memory) {
		return "This is private";
	}
	
	function internalFunc() internal pure returns (string memory) {
		return "This is internal";
	}
	
	function externalFunc() external pure returns (string memory) {
		return "This is external";
	}
}

contract Derived is Base {
	function test() public pure returns (string memory) {
	  // public function can be called internally and externally, so a derived contract can call it
		return publicFunc();         // This will worked.
		// return internalFunc();   // This will work.
		// return privateFunc();    // This will NOT work.
		// return externalFunc();   // This will NOT work.
		
	}
}

contract Consumer {
	function test() public pure returns (string memory) {
		Base b = new Base();
		// can only called public and external functions
		
		// return b.publicFunc();    // This will work.
		return b.externalFunc();     // This will work.
		// return b.privateFunc();   // This will NOT work.
		// return b.internalFunc();  // This will NOT work.
	}
}