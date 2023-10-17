
trait MathTrait {
    fn pow(base: u128, exp: u128) -> u128;
}

impl Math of MathTrait {

    /// Raise a number to a power.
    /// O(log n) time complexity.
    /// * `base` - The number to raise.
    /// * `exp` - The exponent.
    /// # Returns
    /// * `u128` - The result of base raised to the power of exp.
    fn pow(base: u128, exp: u128) -> u128 {
        if exp == 0 {
            1
        } else if exp == 1 {
            base
        } else if exp % 2 == 0 {
            Math::pow(base * base, exp / 2)
        } else {
            base * Math::pow(base * base, (exp - 1) / 2)
        }
    }
}



//-----------------------------------------------
// Unit Tests
//
use loot_underworld::utils::string::{concat, join};

#[test]
#[available_gas(100_000_000)]
fn test_math_pow() {
    assert(Math::pow(0,0) == 1, concat('test_math_pow', '0,0'));
    assert(Math::pow(0,1) == 0, concat('test_math_pow', '0,1'));
    assert(Math::pow(0,2) == 0, concat('test_math_pow', '0,2'));
    assert(Math::pow(0,8) == 0, concat('test_math_pow', '0,8'));
    assert(Math::pow(1,0) == 1, concat('test_math_pow', '1,0'));
    assert(Math::pow(1,1) == 1, concat('test_math_pow', '1,1'));
    assert(Math::pow(1,2) == 1, concat('test_math_pow', '1,2'));
    assert(Math::pow(1,8) == 1, concat('test_math_pow', '1,8'));
    assert(Math::pow(2,0) == 1, concat('test_math_pow', '2,0'));
    assert(Math::pow(2,1) == 2, concat('test_math_pow', '2,1`'));
    assert(Math::pow(2,2) == 4, concat('test_math_pow', '2,2'));
    assert(Math::pow(2,8) == 256, concat('test_math_pow', '2,8'));
    assert(Math::pow(10,0) == 1, concat('test_math_pow', '10,0'));
    assert(Math::pow(10,1) == 10, concat('test_math_pow', '10,1`'));
    assert(Math::pow(10,2) == 100, concat('test_math_pow', '10,2'));
    assert(Math::pow(10,8) == 100_000_000, concat('test_math_pow', '10,8'));
}
