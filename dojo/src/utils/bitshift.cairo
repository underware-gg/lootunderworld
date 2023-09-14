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
// let x: u128 = 1
// BitShift::shl(x, 8)

trait BitShift<T> {
    fn fpow(x: T, n: T) -> T;
    fn shl(x: T, n: T) -> T;
    fn shr(x: T, n: T) -> T;
    fn bit(n: T) -> T;
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
    fn bit(mut n: u8) -> u8 {
        if n >= 8 { return 0; }
        let mut result: u8 = 1;
        loop {
            if n == 0 { break; }
            result *= 2;
            n -= 1;
        };
        result
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
    fn bit(mut n: u16) -> u16 {
        if n >= 16 { return 0; }
        let mut result: u16 = 1;
        loop {
            if n == 0 { break; }
            result *= 2;
            n -= 1;
        };
        result
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
    fn bit(mut n: u32) -> u32 {
        if n >= 32 { return 0; }
        let mut result: u32 = 1;
        loop {
            if n == 0 { break; }
            result *= 2;
            n -= 1;
        };
        result
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
    fn bit(mut n: u64) -> u64 {
        if n >= 64 { return 0; }
        let mut result: u64 = 1;
        loop {
            if n == 0 { break; }
            result *= 2;
            n -= 1;
        };
        result
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
    fn bit(mut n: u128) -> u128 {
        if n >= 128 { return 0; }
        let mut result: u128 = 1;
        loop {
            if n == 0 { break; }
            result *= 2;
            n -= 1;
        };
        result
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
    fn bit(mut n: u256) -> u256 {
        if n >= 256 { return 0; }
        let mut result: u256 = 1;
        loop {
            if n == 0 { break; }
            result *= 2;
            n -= 1;
        };
        result
    }
}

#[test]
#[available_gas(2_000_000)]
fn test_bit_u8() {
    let mut n: u8 = 8;
    assert(U8BitShift::bit(0) == 0x1, 'test_bit_u8_0');
    assert(U8BitShift::bit(1) == 0x2, 'test_bit_u8_1');
    assert(U8BitShift::bit(2) == 0x4, 'test_bit_u8_2');
    assert(U8BitShift::bit(3) == 0x8, 'test_bit_u8_3');
    assert(U8BitShift::bit(4) == 0x10, 'test_bit_u8_4');
    assert(U8BitShift::bit(5) == 0x20, 'test_bit_u8_5');
    assert(U8BitShift::bit(6) == 0x40, 'test_bit_u8_6');
    assert(U8BitShift::bit(7) == 0x80, 'test_bit_u8_7');
    assert(U8BitShift::bit(8) == 0x0, 'test_bit_u8_8');
    loop {
        if n == 0 { break; }
        assert(U8BitShift::bit(n) == U8BitShift::shl(1, n), 'test_bit_u8');
        n -= 1;
    };
}

#[test]
#[available_gas(1_000_000_00)]
fn test_bit_u128() {
    let mut n: u128 = 128;
    assert(U128BitShift::bit(0) == 0x1, 'test_bit_u128_0');
    assert(U128BitShift::bit(1) == 0x2, 'test_bit_u128_1');
    assert(U128BitShift::bit(2) == 0x4, 'test_bit_u128_2');
    assert(U128BitShift::bit(n) == 0x0, 'test_bit_u128_n');
    loop {
        if n == 0 { break; }
        assert(U128BitShift::bit(n) == U128BitShift::shl(1, n), 'test_bit_u128');
        n -= 2;
    };
}

#[test]
#[available_gas(1_000_000_000)]
fn test_bit_u256() {
    let mut n: u256 = 256;
    assert(U256BitShift::bit(0) == 0x1, 'test_bit_u256_0');
    assert(U256BitShift::bit(1) == 0x2, 'test_bit_u256_1');
    assert(U256BitShift::bit(2) == 0x4, 'test_bit_u256_2');
    assert(U256BitShift::bit(n) == 0x0, 'test_bit_u256_n');
    loop {
        if n == 0 { break; }
        assert(U256BitShift::bit(n) == U256BitShift::shl(1, n), 'test_bit_u256');
        n -= 4;
    };
}
