// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";



// Fallback function is a special function available to a contract. It has following features −

// It is called when a non-existent function is called on the contract.
// It is required to be marked external.
// It has no name.
// It has no arguments
// It can not return any thing.
// It can be defined one per contract.
// If not marked payable, it will throw exception if contract receives plain ether without data.




interface ICheck {
    function check() external;
}
contract Test{
    
    function callSink(address sink) public payable {
      address payable sinkPayable = payable(sink);

        sinkPayable.transfer(2 ether);

        // (bool sent,) = sinkPayable.call{value: 1000000000}("");

        // require(sent,"");

        // (bool success, bytes memory data) = sinkPayable.call{value: msg.value, gas: 5000}(
        //     abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
        // );

        // require(success, "Error");

        // ICheck(sink).check();

        (bool success, )=sinkPayable.call(
            abi.encodeWithSignature("setVars(uint256)", 1)
            );

            console.log(success);

        //     (bool succes, )=  sinkPayable.call(
        //     abi.encodeWithSignature("check()")
        // );

        // console.log(succes);
        (bool succe, ) = sinkPayable.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", 1)
        );

        console.log(succe);
        
   }
}