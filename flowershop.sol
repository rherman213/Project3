// SPDX-License-Identifier: MIT

// Only allow compiler versions from 0.7.0 to (not including) 0.9.0

//Ryan Herman cmpsc297 from module3 guided programming
pragma solidity >=0.7.0 <0.9.0;

contract FlowerShop {

    // State variables
    address public owner;
    bool shopIsOpen;
    mapping (address => uint) tulipStock;
    mapping (address => uint) roseStock;
    mapping (address => uint) peonyStock;
    mapping (address => uint) orchidStock;
    mapping (address => uint) bouquets;

    // On creation...
    constructor () {
        // Set the owner as the contract's deployer
        owner = msg.sender;

        // Set initial flower stocks
        tulipStock[address(this)]  = 1000;
        roseStock[address(this)]   = 1000;
        peonyStock[address(this)]  = 1000;
        orchidStock[address(this)] = 1000;
        bouquets[address(this)]    = 0;

        // The shop is initially closed
        shopIsOpen = true;
    }

    // Function to compare two strings
    function compareStrings(string memory a, string memory b) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked(b)));
    }

    // Let the owner restock the shop
    function restock(uint amount, string memory flowerType) public {
        // Only the owner can restock!
        require(msg.sender == owner, "Only the owner can restock the machine!");

        // Refill the stock based on the type passed in
        if (compareStrings(flowerType, "tulip")) {
            tulipStock[address(this)] += amount;
        } else if (compareStrings(flowerType, "rose")) {
            roseStock[address(this)] += amount;
        } else if (compareStrings(flowerType, "peony")) {
            peonyStock[address(this)] += amount;
        } else if (compareStrings(flowerType, "orchid")) {
            orchidStock[address(this)] += amount;
        } else if (compareStrings(flowerType, "all")) {
            tulipStock[address(this)] += amount;
            roseStock[address(this)] += amount;
            peonyStock[address(this)] += amount;
            orchidStock[address(this)] += amount;
        }
    }

    // Let the owner open and close the shop
    function openOrCloseShop() public returns (string memory) {
        if (shopIsOpen) {
            shopIsOpen = false;
            return "Shop is now closed.";
        } else {
            shopIsOpen = true;
            return "Shop is now open.";
        }
    }

    // Purchase a flower from the shop
    function purchase(uint amount, string memory flowerType) public payable {
        require(shopIsOpen == true, "The shop is closed and you may not buy flowers.");
        require(msg.value >= amount * 1 ether, "You must pay at least 1 ETH per flower arrangement!");

        // Sell a flower arrangement based on type asked
        if (compareStrings(flowerType, "tulip")) {
            tulipStock[address(this)] -= amount;
            tulipStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "rose")) {
            roseStock[address(this)] -= amount;
            roseStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "peony")) {
            peonyStock[address(this)] -= amount;
            peonyStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "orchid")) {
            orchidStock[address(this)] -= amount;
            orchidStock[msg.sender] += amount;
        } else if (compareStrings(flowerType, "bouquet")) {
            tulipStock[address(this)] -= amount;
            roseStock[address(this)] -= amount;
            peonyStock[address(this)] -= amount;
            orchidStock[address(this)] -= amount;

            bouquets[msg.sender] += amount;
        }
    }

    // Get stock of a specific type of flower
    function getStock(string memory flowerType) public view returns (uint) {
        // Get stock of a flower based on the type passed in
        if (compareStrings(flowerType, "tulip")) {
            return tulipStock[address(this)];
        } else if (compareStrings(flowerType, "rose")) {
            return roseStock[address(this)];
        } else if (compareStrings(flowerType, "peony")) {
            return peonyStock[address(this)];
        } else if (compareStrings(flowerType, "orchid")) {
            return orchidStock[address(this)];
        } else {
            return 0;
        }
    }
}
