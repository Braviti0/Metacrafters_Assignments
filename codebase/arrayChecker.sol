    // generic function (checks if a value is within a given integer array)
    function checkValue(uint32 value, uint32[] memory iterable) public pure returns (bool x) {
        for (uint i = 0; i < iterable.length; i++) {
                if (iterable[i] == value) {
                    return true;
            }
        }
        return false;
    }

    // generic function (checks if an address is within a given address array)
    function checkAddress(address value, address[] memory iterable) public pure returns (bool x, uint y) {
        for (uint i = 0; i < iterable.length; i++) {
                if (iterable[i] == value) {
                    return(true, i);
            } 
        }
        return(false, 0);
    }