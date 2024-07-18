// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract ClientBook {
		struct Person {
				string name;
				bool isVip;
				address walletAddress;
		}

		Person[] public clients;

		function addClient(string memory name, bool isVip, address walletAddress) public {
				clients.push(Person(name, isVip, walletAddress));
		}

		function getClientInfo(address _address) public view returns (Person memory) {
				for (uint256 i = 0; i < clients.length; i++) {
						if (clients[i].walletAddress == _address) {
								return clients[i];
						}
				}
				return Person("", false, address(0));
		}
}
