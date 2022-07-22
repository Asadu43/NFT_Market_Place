
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract Sink{

    event Log(string s);

    event Received(address caller, uint amount, string message);


    fallback() external payable {
        emit Log("Hello");
    
    }

    receive() external payable{
        emit Log("Hello Receive");
    }

    function foo(string memory _message, uint _x) public payable  {
        emit Received(msg.sender, msg.value, _message);

        // return _x + 1;
    }


    function check() public view returns(uint256){
        console.log("Hello1");
        console.log("1");
        return address(this).balance;
    }


        function check2() public view returns(uint256){
        console.log("Hello1");
        console.log("1");
        return address(this).balance;
    }

        function setVars(uint _num) public payable {
        emit Received(msg.sender, msg.value, "1");
    }

}