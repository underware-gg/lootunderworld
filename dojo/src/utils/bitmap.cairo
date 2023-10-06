use loot_underworld::utils::bitwise::{U256Bitwise};
use loot_underworld::types::dir::{Dir, DirTrait};

//
// use editor to create bitmaps: http://localhost:5173/editor/
//
// 11111111
// 00000000
// ...
const FIRST_ROW: u256 = 0xffff000000000000000000000000000000000000000000000000000000000000;
// 10000000
// 10000000
// ...
const FIRST_COLUMN: u256 = 0x8000800080008000800080008000800080008000800080008000800080008000;

trait BitmapTrait {
    fn bit_tile(i: usize) -> usize;
    fn bit_xy(x: usize, y: usize) -> usize;
    fn is_set_tile(bitmap: u256, i: usize) -> bool;
    fn is_set_xy(bitmap: u256, x: usize, y: usize) -> bool;
    fn set_tile(bitmap: u256, i: usize) -> u256;
    fn set_xy(bitmap: u256, x: usize, y: usize) -> u256;
    fn unset(bitmap: u256, x: usize, y: usize) -> u256;

    fn RotateNorthTo(bitmap: u256, dir: Dir) -> u256;
    fn Rotate90CW(bitmap: u256) -> u256;
    fn Rotate90CCW(bitmap: u256) -> u256;
    fn Rotate180(bitmap: u256) -> u256;

    fn get_min_x(bitmap: u256) -> usize;
    fn get_min_y(bitmap: u256) -> usize;
    fn get_max_x(bitmap: u256) -> usize;
    fn get_max_y(bitmap: u256) -> usize;
}

impl Bitmap of BitmapTrait {

    // returns the bit number of a tile position (e.g. doors)
    // starting from the map's top left
    #[inline(always)]
    fn bit_tile(i: usize) -> usize {
       (255 - i)
    }

    // returns the bit number of a [x, y] position
    // starting from the map's top left
    #[inline(always)]
    fn bit_xy(x: usize, y: usize) -> usize {
       (255 - (y * 16 + x))
    }

    #[inline(always)]
    fn is_set_tile(bitmap: u256, i: usize) -> bool {
        U256Bitwise::is_set(bitmap, Bitmap::bit_tile(i))
    }

    #[inline(always)]
    fn is_set_xy(bitmap: u256, x: usize, y: usize) -> bool {
        U256Bitwise::is_set(bitmap, Bitmap::bit_xy(x, y))
    }

    #[inline(always)]
    fn set_tile(bitmap: u256, i: usize) -> u256 {
        U256Bitwise::set(bitmap, Bitmap::bit_tile(i))
    }

    #[inline(always)]
    fn set_xy(bitmap: u256, x: usize, y: usize) -> u256 {
        U256Bitwise::set(bitmap, Bitmap::bit_xy(x, y))
    }

    #[inline(always)]
    fn unset(bitmap: u256, x: usize, y: usize) -> u256 {
        U256Bitwise::unset(bitmap, Bitmap::bit_xy(x, y))
    }

    fn RotateNorthTo(bitmap: u256, dir: Dir) -> u256 {
        // rotate North to...
        match dir {
            Dir::North => bitmap,
            Dir::East => Bitmap::Rotate90CW(bitmap),
            Dir::West => Bitmap::Rotate90CCW(bitmap),
            Dir::South => Bitmap::Rotate180(bitmap),
            Dir::Over => bitmap,
            Dir::Under => bitmap,
        }
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

    fn get_min_x(bitmap: u256) -> usize {
        let mut n: usize = 0;
        loop {
            if (n == 15) { break; }
            if (bitmap & U256Bitwise::shr(FIRST_COLUMN, n) != 0 ) { break; } 
            n += 1;
        };
        n
    }
    fn get_min_y(bitmap: u256) -> usize {
        let mut n: usize = 0;
        loop {
            if (n == 15) { break; }
            if (bitmap & U256Bitwise::shr(FIRST_ROW, n * 16) != 0 ) { break; } 
            n += 1;
        };
        n
    }
    fn get_max_x(bitmap: u256) -> usize {
        let mut n: usize = 15;
        loop {
            if (n == 0) { break; }
            if (bitmap & U256Bitwise::shr(FIRST_COLUMN, n) != 0 ) { break; } 
            n -= 1;
        };
        n
    }
    fn get_max_y(bitmap: u256) -> usize {
        let mut n: usize = 15;
        loop {
            if (n == 0) { break; }
            if (bitmap & U256Bitwise::shr(FIRST_ROW, n * 16) != 0 ) { break; } 
            n -= 1;
        };
        n
    }
}



//----------------------------------------------
// Unit tests
//
use debug::PrintTrait;

#[test]
#[available_gas(100_000_000)]
fn test_bitmap_inline() {
    let bit1: usize = Bitmap::bit_xy(8, 8);
    let bit2: usize = Bitmap::bit_xy(4 + 4, 4 + 4);
    assert(bit1 != 0, 'test_bitmap_inline_bit_zero');
    assert(bit1 == bit2, 'test_bitmap_inline_bit_equals');
    let bmp1: u256 = Bitmap::set_xy(0, 8, 8);
    let bmp2: u256 = Bitmap::set_xy(0, 4 + 4, 4 + 4);
    assert(bmp1 != 0, 'test_bitmap_inline_set_zero');
    assert(bmp1 == bmp2, 'test_bitmap_inline_set_equals');
}

#[test]
#[available_gas(1_000_000_000)]
fn test_get_min_max_x_y() {
    assert(Bitmap::get_min_x(0) == 15, 'test_get_min_x_zero_0');
    assert(Bitmap::get_max_x(0) == 0, 'test_get_max_x_zero_15');
    assert(Bitmap::get_min_y(0) == 15, 'test_get_min_y_zero_0');
    assert(Bitmap::get_max_y(0) == 0, 'test_get_max_y_zero_15');

    assert(Bitmap::get_min_x(Bitmap::set_xy(0, 0, 0)) == 0, 'test_get_min_x_0_0');
    assert(Bitmap::get_max_x(Bitmap::set_xy(0, 0, 0)) == 0, 'test_get_max_x_0_0');
    assert(Bitmap::get_min_y(Bitmap::set_xy(0, 0, 0)) == 0, 'test_get_min_y_0_0');
    assert(Bitmap::get_max_y(Bitmap::set_xy(0, 0, 0)) == 0, 'test_get_max_y_0_0');

    assert(Bitmap::get_min_x(Bitmap::set_xy(0, 2, 2)) == 2, 'test_get_min_x_2_2');
    assert(Bitmap::get_max_x(Bitmap::set_xy(0, 2, 2)) == 2, 'test_get_max_x_2_2');
    assert(Bitmap::get_min_y(Bitmap::set_xy(0, 2, 2)) == 2, 'test_get_min_y_2_2');
    assert(Bitmap::get_max_y(Bitmap::set_xy(0, 2, 2)) == 2, 'test_get_max_y_2_2');

    assert(Bitmap::get_min_x(Bitmap::set_xy(0, 15, 15)) == 15, 'test_get_min_x_15_15');
    assert(Bitmap::get_max_x(Bitmap::set_xy(0, 15, 15)) == 15, 'test_get_max_x_15_15');
    assert(Bitmap::get_min_y(Bitmap::set_xy(0, 15, 15)) == 15, 'test_get_min_y_15_15');
    assert(Bitmap::get_max_y(Bitmap::set_xy(0, 15, 15)) == 15, 'test_get_max_y_15_15');

    assert(Bitmap::get_min_x(Bitmap::set_xy(0, 8, 0)) == 8, 'test_get_min_x_8_0');
    assert(Bitmap::get_max_x(Bitmap::set_xy(0, 8, 0)) == 8, 'test_get_max_x_8_0');
    assert(Bitmap::get_min_x(Bitmap::set_xy(0, 8, 15)) == 8, 'test_get_min_x_8_15');
    assert(Bitmap::get_max_x(Bitmap::set_xy(0, 8, 15)) == 8, 'test_get_max_x_8_15');
    let bmpx1 = Bitmap::set_xy(0, 0, 1) | Bitmap::set_xy(0, 15, 14);
    assert(Bitmap::get_min_x(bmpx1) == 0, 'test_get_min_x_0');
    assert(Bitmap::get_max_x(bmpx1) == 15, 'test_get_max_x_15');
    let bmpx2 = Bitmap::set_xy(0, 4, 0) | Bitmap::set_xy(0, 12, 15);
    assert(Bitmap::get_min_x(bmpx2) == 4, 'test_get_min_x_4');
    assert(Bitmap::get_max_x(bmpx2) == 12, 'test_get_max_x_12');
    let bmpy1 = Bitmap::set_xy(0, 1, 0) | Bitmap::set_xy(0, 14, 15);
    assert(Bitmap::get_min_y(bmpy1) == 0, 'test_get_min_y_0');
    assert(Bitmap::get_max_y(bmpy1) == 15, 'test_get_max_y_15');
    let bmpy2 = Bitmap::set_xy(0, 0, 4) | Bitmap::set_xy(0, 15, 12);
    assert(Bitmap::get_min_y(bmpy2) == 4, 'test_get_min_y_4');
    assert(Bitmap::get_max_y(bmpy2) == 12, 'test_get_max_y_12');
}
