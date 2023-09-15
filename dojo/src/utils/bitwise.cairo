use traits::Into;
use option::OptionTrait;
use debug::PrintTrait;

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
        pow(base * base, exp / 2)
    } else {
        base * pow(base * base, (exp - 1) / 2)
    }
}

/// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// * `base` - Base in which to count the digits.
/// # Returns
/// * `felt252` - The number of digits in num of base
fn count_digits_of_base(mut num: u128, base: u128) -> u128 {
    let mut res = 0;
    loop {
        if num == 0 {
            break res;
        } else {
            num = num / base;
        }
        res += 1;
    }
}


// call examples:
// Bitwise::shl(1, 8)
// Bitwise::bit(8)

trait Bitwise<T> {
    fn bit(n: usize) -> T;
    fn shl(x: T, n: usize) -> T;
    fn shr(x: T, n: usize) -> T;
    fn isSet(x: T, n: usize) -> bool;
}

impl U8Bitwise of Bitwise<u8> {
    fn bit(n: usize) -> u8 {
        if n == 0 { return 0x1; }
        if n == 1 { return 0x2; }
        if n == 2 { return 0x4; }
        if n == 3 { return 0x8; }
        if n == 4 { return 0x10; }
        if n == 5 { return 0x20; }
        if n == 6 { return 0x40; }
        if n == 7 { return 0x80; }
        0
    }
    fn shl(x: u8, n: usize) -> u8 {
        x * U8Bitwise::bit(n)
    }
    fn shr(x: u8, n: usize) -> u8 {
        x / U8Bitwise::bit(n)
    }
    fn isSet(x: u8, n: usize) -> bool {
        ((U8Bitwise::shr(x, n) & 1) != 0)
    }
}

impl U16Bitwise of Bitwise<u16> {
    fn bit(n: usize) -> u16 {
        if n < 8 { return U8Bitwise::bit(n).into(); }
        if n < 16 { return U8Bitwise::bit(n-8).into() * 0x100; }
        0
    }
    fn shl(x: u16, n: usize) -> u16 {
        x * U16Bitwise::bit(n)
    }
    fn shr(x: u16, n: usize) -> u16 {
        x / U16Bitwise::bit(n)
    }
    fn isSet(x: u16, n: usize) -> bool {
        ((U16Bitwise::shr(x, n) & 1) != 0)
    }
}

impl U32Bitwise of Bitwise<u32> {
    fn bit(n: usize) -> u32 {
        if n < 16 { return U16Bitwise::bit(n).into(); }
        if n < 32 { return U16Bitwise::bit(n-16).into() * 0x10000; }
        0
    }
    fn shl(x: u32, n: u32) -> u32 {
        x * U32Bitwise::bit(n)
    }
    fn shr(x: u32, n: u32) -> u32 {
        x / U32Bitwise::bit(n)
    }
    fn isSet(x: u32, n: u32) -> bool {
        ((U32Bitwise::shr(x, n) & 1) != 0)
    }
}

impl U64Bitwise of Bitwise<u64> {
    fn bit(n: usize) -> u64 {
        if n < 32 { return U32Bitwise::bit(n).into(); }
        if n < 64 { return U32Bitwise::bit(n-32).into() * 0x100000000; }
        0
    }
    fn shl(x: u64, n: usize) -> u64 {
        x * U64Bitwise::bit(n)
    }
    fn shr(x: u64, n: usize) -> u64 {
        x / U64Bitwise::bit(n)
    }
    fn isSet(x: u64, n: usize) -> bool {
        ((U64Bitwise::shr(x, n) & 1) != 0)
    }
}

impl U128Bitwise of Bitwise<u128> {
    fn bit(n: usize) -> u128 {
        if n < 64 { return U64Bitwise::bit(n).into(); }
        if n < 128 { return U64Bitwise::bit(n-64).into() * 0x10000000000000000; }
        0
    }
    fn shl(x: u128, n: usize) -> u128 {
        x * U128Bitwise::bit(n)
    }
    fn shr(x: u128, n: usize) -> u128 {
        x / U128Bitwise::bit(n)
    }
    fn isSet(x: u128, n: usize) -> bool {
        ((U128Bitwise::shr(x, n) & 1) != 0)
    }
}

impl U256Bitwise of Bitwise<u256> {
    fn bit(n: usize) -> u256 {
        if n < 128 { return u256 { low: U128Bitwise::bit(n), high: 0x0 }; }
        if n < 256 { return u256 { low: 0x0, high: U128Bitwise::bit(n-128) }; }
        0
    }
    fn shl(x: u256, n: usize) -> u256 {
        x * U256Bitwise::bit(n)
    }
    fn shr(x: u256, n: usize) -> u256 {
        x / U256Bitwise::bit(n)
    }
    fn isSet(x: u256, n: usize) -> bool {
        ((U256Bitwise::shr(x, n) & 1) != 0)
    }
}



#[test]
#[available_gas(50_000_000)]
fn test_bit() {
    let mut bit: u256 = 0x1;
    let mut n: usize = 0;
    loop {
        if n < 8 {
            assert(U8Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_8_8');
            assert(U16Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_8_16');
            assert(U32Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_8_32');
            assert(U64Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_8_64');
            assert(U128Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_8_128');
            assert(U256Bitwise::bit(n) == bit, 'test_bit_8_256');
        } else if n < 16 {
            assert(U8Bitwise::bit(n) == 0x0, 'test_bit_16_8');
            assert(U16Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_16_16');
            assert(U32Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_16_32');
            assert(U64Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_16_64');
            assert(U128Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_16_128');
            assert(U256Bitwise::bit(n) == bit, 'test_bit_16_256');
        } else if n < 32 {
            assert(U16Bitwise::bit(n) == 0x0, 'test_bit_32_16');
            assert(U32Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_16_32');
            assert(U64Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_16_64');
            assert(U128Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_16_128');
            assert(U256Bitwise::bit(n) == bit, 'test_bit_16_256');
        } else if n < 64 {
            assert(U32Bitwise::bit(n) == 0x0, 'test_bit_64_32');
            assert(U64Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_64_64');
            assert(U128Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_64_128');
            assert(U256Bitwise::bit(n) == bit, 'test_bit_64_256');
        } else if n < 128 {
            assert(U64Bitwise::bit(n) == 0x0, 'test_bit_128_64');
            assert(U128Bitwise::bit(n) == bit.try_into().unwrap(), 'test_bit_128_128');
            assert(U256Bitwise::bit(n) == bit, 'test_bit_128_256');
        } else {
            assert(U128Bitwise::bit(n) == 0x0, 'test_bit_256_128');
            assert(U256Bitwise::bit(n) == bit, 'test_bit_256_256');
        }
        n += 1;
        if n == 256 { break; }
        bit *= 2;
    };
}

const U8_ONE_LEFT: u8     = 0x80;
const U16_ONE_LEFT: u16   = 0x8000;
const U32_ONE_LEFT: u32   = 0x80000000;
const U64_ONE_LEFT: u64   = 0x8000000000000000;
const U128_ONE_LEFT: u128 = 0x80000000000000000000000000000000;
const U256_ONE_LEFT: u256 = 0x8000000000000000000000000000000000000000000000000000000000000000;

#[test]
#[available_gas(300_000)]
fn test_shift_u8() {
    let mut n: usize = 0;
    loop {
        if n == 8 { break; }
        let bit = U8Bitwise::bit(n);
        assert(bit == U8Bitwise::shl(1, n), 'test_shl_u8');
        assert(bit == U8Bitwise::shr(U8_ONE_LEFT, 7-n), 'test_shr_u8');
        n += 1;
    };
}

#[test]
#[available_gas(1_000_000)]
fn test_shift_u16() {
    let mut n: usize = 0;
    loop {
        if n == 16 { break; }
        let bit = U16Bitwise::bit(n);
        assert(bit == U16Bitwise::shl(1, n), 'test_shl_u16');
        assert(bit == U16Bitwise::shr(U16_ONE_LEFT, 15-n), 'test_shr_u16');
        n += 1;
    };
}

#[test]
#[available_gas(3_000_000)]
fn test_shift_u32() {
    let mut n: usize = 0;
    loop {
        if n == 32 { break; }
        let bit = U32Bitwise::bit(n);
        assert(bit == U32Bitwise::shl(1, n), 'test_shl_u32');
        assert(bit == U32Bitwise::shr(U32_ONE_LEFT, (31-n)), 'test_shr_u32');
        n += 1;
    };
}

#[test]
#[available_gas(6_000_000)]
fn test_shift_u64() {
    let mut n: usize = 0;
    loop {
        if n == 64 { break; }
        let bit = U64Bitwise::bit(n);
        assert(bit == U64Bitwise::shl(1, n), 'test_shl_u64');
        assert(bit == U64Bitwise::shr(U64_ONE_LEFT, (63-n)), 'test_shr_u64');
        n += 1;
    };
}

#[test]
#[available_gas(20_000_000)]
fn test_shift_u128() {
    let mut n: usize = 0;
    loop {
        if n == 128 { break; }
        let bit = U128Bitwise::bit(n);
        assert(bit == U128Bitwise::shl(1, n), 'test_shl_u128');
        assert(bit == U128Bitwise::shr(U128_ONE_LEFT, (127-n)), 'test_shr_u128');
        n += 1;
    };
}

#[test]
#[available_gas(50_000_000)]
fn test_shift_u256() {
    let mut n: usize = 0;
    loop {
        if n == 256 { break; }
        let bit = U256Bitwise::bit(n);
        assert(bit == U256Bitwise::shl(1, n), 'test_shl_u256');
        assert(bit == U256Bitwise::shr(U256_ONE_LEFT, (255-n)), 'test_shr_u256');
        n += 1;
    };
}
