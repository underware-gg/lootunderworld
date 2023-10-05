use loot_underworld::utils::bitwise::{U256Bitwise};

fn BitmapRotate90CW(input: u256) -> u256 {
    let mut result: u256 = 0;
    let mut n: usize = 0;
    loop {
        if n == 256 { break; }
        if (U256Bitwise::isSet(input, n)) {
            let x = n % 16;
            let y = n / 16;
            let xx = 15 - y;
            let yy = x;
            result = U256Bitwise::set(result, yy * 16 + xx);
        }
        n += 1;
    };
    result
}

fn BitmapRotate90CCW(input: u256) -> u256 {
    let mut result: u256 = 0;
    let mut n: usize = 0;
    loop {
        if n == 256 { break; }
        if (U256Bitwise::isSet(input, n)) {
            let x = n % 16;
            let y = n / 16;
            let xx = y;
            let yy = 15 - x;
            result = U256Bitwise::set(result, yy * 16 + xx);
        }
        n += 1;
    };
    result
}

fn BitmapRotate180(input: u256) -> u256 {
    let mut result: u256 = 0;
    let mut n: usize = 0;
    loop {
        if n == 256 { break; }
        if (U256Bitwise::isSet(input, n)) {
            let x = n % 16;
            let y = n / 16;
            let xx = 15 - x;
            let yy = 15 - y;
            result = U256Bitwise::set(result, yy * 16 + xx);
        }
        n += 1;
    };
    result
}
