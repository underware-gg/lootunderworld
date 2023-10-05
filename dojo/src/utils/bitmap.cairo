use loot_underworld::utils::bitwise::{U256Bitwise};

trait BitmapTrait {
    fn is_set(bitmap: u256, x: usize, y: usize) -> bool;
    fn set(bitmap: u256, x: usize, y: usize) -> u256;
    fn unset(bitmap: u256, x: usize, y: usize) -> u256;
    fn Rotate90CW(bitmap: u256) -> u256;
    fn Rotate90CCW(bitmap: u256) -> u256;
    fn Rotate180(bitmap: u256) -> u256;
}

impl Bitmap of BitmapTrait {

    #[inline(always)]
    fn is_set(bitmap: u256, x: usize, y: usize) -> bool {
        U256Bitwise::is_set(bitmap, 255 - (y * 16 + x))
    }

    #[inline(always)]
    fn set(bitmap: u256, x: usize, y: usize) -> u256 {
        U256Bitwise::set(bitmap, 255 - (y * 16 + x))
    }

    #[inline(always)]
    fn unset(bitmap: u256, x: usize, y: usize) -> u256 {
        U256Bitwise::unset(bitmap, 255 - (y * 16 + x))
    }

    fn Rotate90CW(bitmap: u256) -> u256 {
        let mut result: u256 = 0;
        let mut n: usize = 0;
        loop {
            if n == 256 { break; }
            if (U256Bitwise::is_set(bitmap, n)) {
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
            if (U256Bitwise::is_set(bitmap, n)) {
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
            if (U256Bitwise::is_set(bitmap, n)) {
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

#[test]
#[available_gas(100_000_000)]
fn test_bitmap_inline() {
    let bmp1: u256 = Bitmap::set(0, 8, 8);
    let bmp2: u256 = Bitmap::set(0, 4 + 4, 4 + 4);
    assert(bmp1 != 0, 'test_bitmap_inline_zero');
    assert(bmp1 == bmp2, 'test_bitmap_inline_equals');
}
