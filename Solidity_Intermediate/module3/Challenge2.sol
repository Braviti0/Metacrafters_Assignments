// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ICounter {
    function count() external view returns (uint);

    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}

pragma solidity ^0.5.0;

contract CalciAbstract {
   function getResult() public view returns(uint);
}
contract Compute is CalciAbstract {
   function getResult() public view returns(uint) {
      uint a = 1;
      uint b = 2;
      uint result = a + b;
      return result;
   }
}