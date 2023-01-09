contract StorageC {
  struct LotteryNumber{
    uint256 Lnumber;
    string selection;
  }  mapping(address => LotteryNumber) LotteryNumber;
}

function multiply(uint256 num) external pure returns(uint256) {
  uint256 result = num * num;  return result;
}
