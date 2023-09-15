//
// from Alexandria Cairo library (MIT licence)
// https://github.com/keep-starknet-strange/alexandria/blob/main/src/math/src/lib.cairo#L40
//

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
// BitShift::shl(1, 8)
// BitShift::bit(8)

trait BitShift<T> {
    fn fpow(x: T, n: T) -> T;
    fn shl(x: T, n: T) -> T;
    fn shr(x: T, n: T) -> T;
    fn bit(n: usize) -> T;
}

impl U8BitShift of BitShift<u8> {
    fn fpow(x: u8, n: u8) -> u8 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u8, n: u8) -> u8 {
        if n >= 8 { return 0; }
        x * BitShift::fpow(2, n)
    }
    fn shr(x: u8, n: u8) -> u8 {
        if n >= 8 { return 0; }
        x / BitShift::fpow(2, n)
    }
    fn bit(mut n: usize) -> u8 {
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
}

impl U16BitShift of BitShift<u16> {
    fn fpow(x: u16, n: u16) -> u16 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u16, n: u16) -> u16 {
        if n >= 16 { return 0; }
        x * BitShift::fpow(2, n)
    }
    fn shr(x: u16, n: u16) -> u16 {
        if n >= 16 { return 0; }
        x / BitShift::fpow(2, n)
    }
    fn bit(mut n: usize) -> u16 {
        if n < 8 { return U8BitShift::bit(n).into(); }
        if n < 16 { return U8BitShift::bit(n-8).into() * 0x100; }
        0
    }
}

impl U32BitShift of BitShift<u32> {
    fn fpow(x: u32, n: u32) -> u32 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u32, n: u32) -> u32 {
        if n >= 32 { return 0; }
        x * BitShift::fpow(2, n)
    }
    fn shr(x: u32, n: u32) -> u32 {
        if n >= 32 { return 0; }
        x / BitShift::fpow(2, n)
    }
    fn bit(mut n: usize) -> u32 {
        if n < 16 { return U16BitShift::bit(n).into(); }
        if n < 32 { return U16BitShift::bit(n-16).into() * 0x10000; }
        0
    }
}

impl U64BitShift of BitShift<u64> {
    fn fpow(x: u64, n: u64) -> u64 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u64, n: u64) -> u64 {
        if n >= 64 { return 0; }
        x * BitShift::fpow(2, n)
    }
    fn shr(x: u64, n: u64) -> u64 {
        if n >= 64 { return 0; }
        x / BitShift::fpow(2, n)
    }
    fn bit(mut n: usize) -> u64 {
        if n < 32 { return U32BitShift::bit(n).into(); }
        if n < 64 { return U32BitShift::bit(n-32).into() * 0x100000000; }
        0
    }
}

impl U128BitShift of BitShift<u128> {
    fn fpow(x: u128, n: u128) -> u128 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u128, n: u128) -> u128 {
        if n >= 128 { return 0; }
        x * BitShift::fpow(2, n)
    }
    fn shr(x: u128, n: u128) -> u128 {
        if n >= 128 { return 0; }
        x / BitShift::fpow(2, n)
    }
    fn bit(mut n: usize) -> u128 {
        if n < 64 { return U64BitShift::bit(n).into(); }
        if n < 128 { return U64BitShift::bit(n-64).into() * 0x10000000000000000; }
        0
    }
}

impl U256BitShift of BitShift<u256> {
    fn fpow(x: u256, n: u256) -> u256 {
        if n == 0 {
            1
        } else if n == 1 {
            x
        } else if (n & 1) == 1 {
            x * BitShift::fpow(x * x, n / 2)
        } else {
            BitShift::fpow(x * x, n / 2)
        }
    }
    fn shl(x: u256, n: u256) -> u256 {
        if n >= 256 { return 0; }
        x * BitShift::fpow(2, n)
    }
    fn shr(x: u256, n: u256) -> u256 {
        if n >= 256 { return 0; }
        x / BitShift::fpow(2, n)
    }
    fn bit(mut n: usize) -> u256 {
        if n < 128 { return u256 { low: U128BitShift::bit(n), high: 0x0 }; }
        if n < 256 { return u256 { low: 0x0, high: U128BitShift::bit(n-128) }; }
        0
    }
}

#[test]
#[available_gas(1_000_000)]
fn test_bit_u8() {
    assert(U8BitShift::bit(0) == 0x1, 'test_bit_u8_0');
    assert(U8BitShift::bit(1) == 0x2, 'test_bit_u8_1');
    assert(U8BitShift::bit(2) == 0x4, 'test_bit_u8_2');
    assert(U8BitShift::bit(3) == 0x8, 'test_bit_u8_3');
    assert(U8BitShift::bit(4) == 0x10, 'test_bit_u8_4');
    assert(U8BitShift::bit(5) == 0x20, 'test_bit_u8_5');
    assert(U8BitShift::bit(6) == 0x40, 'test_bit_u8_6');
    assert(U8BitShift::bit(7) == 0x80, 'test_bit_u8_7');
    assert(U8BitShift::bit(8) == 0x0, 'test_bit_u8_8');
    let mut n: u8 = 8;
    loop {
        if n == 0 { break; }
        assert(U8BitShift::bit(n.into()) == U8BitShift::shl(1, n), 'test_bit_u8');
        n -= 1;
    };
}

#[test]
#[available_gas(2_000_000)]
fn test_bit_u16() {
    let mut n: u16 = 16;
    loop {
        if n == 0 { break; }
        assert(U16BitShift::bit(n.into()) == U16BitShift::shl(1, n), 'test_bit_u16');
        n -= 2;
    };
}

#[test]
#[available_gas(4_000_000)]
fn test_bit_u32() {
    let mut n: usize = 32;
    loop {
        if n == 0 { break; }
        assert(U32BitShift::bit(n) == U32BitShift::shl(1, n.into()), 'test_bit_u32');
        n -= 1;
    };
}

#[test]
#[available_gas(8_000_000)]
fn test_bit_u64() {
    let mut n: usize = 64;
    loop {
        if n == 0 { break; }
        assert(U64BitShift::bit(n) == U64BitShift::shl(1, n.into()), 'test_bit_u64');
        n -= 1;
    };
}

#[test]
#[available_gas(32_000_000)]
fn test_bit_u128() {
    let mut n: usize = 128;
    loop {
        if n == 0 { break; }
        assert(U128BitShift::bit(n) == U128BitShift::shl(1, n.into()), 'test_bit_u128');
        n -= 1;
    };
}

#[test]
#[available_gas(200_000_000)]
fn test_bit_u256() {
    let mut n: usize = 256;
    loop {
        if n == 0 { break; }
        assert(U256BitShift::bit(n) == U256BitShift::shl(1, n.into()), 'test_bit_u256');
        n -= 1;
    };
}
