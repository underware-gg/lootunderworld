use loot_underworld::utils::bitwise::{U256Bitwise};

trait BitmapTrait {
    fn set(bitmap: u256, x: usize, y: usize) -> u256;
    fn unset(bitmap: u256, x: usize, y: usize) -> u256;
    fn Rotate90CW(bitmap: u256) -> u256;
    fn Rotate90CCW(bitmap: u256) -> u256;
    fn Rotate180(bitmap: u256) -> u256;
}

impl Bitmap of BitmapTrait {

    fn set(bitmap: u256, x: usize, y: usize) -> u256 {
        U256Bitwise::set(bitmap, y * 16 + x)
    }

    fn unset(bitmap: u256, x: usize, y: usize) -> u256 {
        U256Bitwise::unset(bitmap, y * 16 + x)
    }

    fn Rotate90CW(bitmap: u256) -> u256 {
        let mut result: u256 = 0;
        let mut n: usize = 0;
        loop {
            if n == 256 { break; }
            if (U256Bitwise::isSet(bitmap, n)) {
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

    fn Rotate90CCW(bitmap: u256) -> u256 {
        let mut result: u256 = 0;
        let mut n: usize = 0;
        loop {
            if n == 256 { break; }
            if (U256Bitwise::isSet(bitmap, n)) {
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

    fn Rotate180(bitmap: u256) -> u256 {
        let mut result: u256 = 0;
        let mut n: usize = 0;
        loop {
            if n == 256 { break; }
            if (U256Bitwise::isSet(bitmap, n)) {
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
}
