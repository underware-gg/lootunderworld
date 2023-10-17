use loot_underworld::utils::bitwise::{U256Bitwise};
use loot_underworld::types::dir::{Dir, DirTrait};


//
// use editor to create bitmaps: http://localhost:5173/editor/
mod MASK {
    const NONE: u256 = 0x0;
    const ALL: u256  = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    // 11111
    // 10001
    // 11111
    const OUTER: u256 = 0xffff80018001800180018001800180018001800180018001800180018001ffff;
    const INNER: u256 = 0x00007ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe0000;

    // 10001
    // 10001
    // 10001
    const LEFT_COL: u256   = 0x8000800080008000800080008000800080008000800080008000800080008000;
    const RIGHT_COL: u256  = 0x0001000100010001000100010001000100010001000100010001000100010001;
    const OUTER_COLS: u256 = 0x8001800180018001800180018001800180018001800180018001800180018001;
    const INNER_COLS: u256 = 0x7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe7ffe;

    // 11111
    // 00000
    // 11111
    const TOP_ROW: u256    = 0xffff000000000000000000000000000000000000000000000000000000000000;
    const BOTTOM_ROW: u256 = 0x000000000000000000000000000000000000000000000000000000000000ffff;
    const OUTER_ROWS: u256 = 0xffff00000000000000000000000000000000000000000000000000000000ffff;
    const INNER_ROWS: u256 = 0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000;
}

trait BitmapTrait {

    // convert map position form tile (0-255) to xy (0-15,0-15)
    // always starting from the map's top left
    fn tile_to_xy(i: usize) -> (usize, usize);

    // convert map position form xy (0-15,0-15) to tile (0-255)
    // always starting from the map's top left
    fn xy_to_tile(x: usize, y: usize) -> usize;

    // returns the u256 bit number (0-255) of a tile position (e.g. doors)
    fn bit_tile(i: usize) -> usize;

    // returns the u256 bit number (0-255) of a [x, y] position
    fn bit_xy(x: usize, y: usize) -> usize;
    
    // check if a map position is set (is path, not wall)
    fn is_set_tile(bitmap: u256, i: usize) -> bool;
    fn is_set_xy(bitmap: u256, x: usize, y: usize) -> bool;
    
    fn set_tile(bitmap: u256, i: usize) -> u256;
    fn set_xy(bitmap: u256, x: usize, y: usize) -> u256;

    fn unset_tile(bitmap: u256, i: usize) -> u256;
    fn unset_xy(bitmap: u256, x: usize, y: usize) -> u256;

    fn row(bitmap: u256, n: usize) -> u256;
    fn column(bitmap: u256, n: usize) -> u256;

    fn shift_left(bitmap: u256, n: usize) -> u256;
    fn shift_right(bitmap: u256, n: usize) -> u256;
    fn shift_up(bitmap: u256, n: usize) -> u256;
    fn shift_down(bitmap: u256, n: usize) -> u256;

    fn get_range_x(bitmap: u256) -> (usize, usize);
    fn get_range_y(bitmap: u256) -> (usize, usize);
    fn get_min_x(bitmap: u256) -> usize;
    fn get_max_x(bitmap: u256) -> usize;
    fn get_min_y(bitmap: u256) -> usize;
    fn get_max_y(bitmap: u256) -> usize;

    fn rotate_north_to(bitmap: u256, dir: Dir) -> u256;
    fn Rotate_90_cw(bitmap: u256) -> u256;
    fn Rotate_90_ccw(bitmap: u256) -> u256;
    fn Rotate_180(bitmap: u256) -> u256;
}

impl Bitmap of BitmapTrait {

    #[inline(always)]
    fn tile_to_xy(i: usize) -> (usize, usize) {
        (i % 16, i / 16)
    }
    #[inline(always)]
    fn xy_to_tile(x: usize, y: usize) -> usize {
       (y * 16 + x)
    }

    #[inline(always)]
    fn bit_tile(i: usize) -> usize {
       (255 - i)
    }
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
    fn unset_tile(bitmap: u256, i: usize) -> u256 {
        U256Bitwise::unset(bitmap, Bitmap::bit_tile(i))
    }
    #[inline(always)]
    fn unset_xy(bitmap: u256, x: usize, y: usize) -> u256 {
        U256Bitwise::unset(bitmap, Bitmap::bit_xy(x, y))
    }

    #[inline(always)]
    fn row(bitmap: u256, n: usize) -> u256 {
        (bitmap & Bitmap::shift_down(MASK::TOP_ROW, n))
    }
    #[inline(always)]
    fn column(bitmap: u256, n: usize) -> u256 {
        (bitmap & Bitmap::shift_right(MASK::LEFT_COL, n))
    }

    #[inline(always)]
    fn shift_left(bitmap: u256, n: usize) -> u256 {
        if(n == 0) { return bitmap; }
        if(n > 15) { return 0; }
        U256Bitwise::shl(bitmap, n)
    }
    #[inline(always)]
    fn shift_right(bitmap: u256, n: usize) -> u256 {
        if(n == 0) { return bitmap; }
        if(n > 15) { return 0; }
        U256Bitwise::shr(bitmap, n)
    }
    #[inline(always)]
    fn shift_up(bitmap: u256, n: usize) -> u256 {
        if(n == 0) { return bitmap; }
        if(n > 15) { return 0; }
        U256Bitwise::shl(bitmap, n * 16)
    }
    #[inline(always)]
    fn shift_down(bitmap: u256, n: usize) -> u256 {
        if(n == 0) { return bitmap; }
        if(n > 15) { return 0; }
        U256Bitwise::shr(bitmap, n * 16)
    }

    #[inline(always)]
    fn get_range_x(bitmap: u256) -> (usize, usize) {
        (Bitmap::get_min_x(bitmap), Bitmap::get_max_x(bitmap))
    }

    #[inline(always)]
    fn get_range_y(bitmap: u256) -> (usize, usize) {
        (Bitmap::get_min_y(bitmap), Bitmap::get_max_y(bitmap))
    }

    fn get_min_x(bitmap: u256) -> usize {
        let mut n: usize = 0;
        loop {
            if (n == 15) { break; }
            if (Bitmap::column(bitmap, n) != 0 ) { break; }
            n += 1;
        };
        n
    }
    fn get_max_x(bitmap: u256) -> usize {
        let mut n: usize = 15;
        loop {
            if (n == 0) { break; }
            if (Bitmap::column(bitmap, n) != 0 ) { break; }
            n -= 1;
        };
        n
    }
    fn get_min_y(bitmap: u256) -> usize {
        let mut n: usize = 0;
        loop {
            if (n == 15) { break; }
            if (Bitmap::row(bitmap, n) != 0 ) { break; }
            n += 1;
        };
        n
    }
    fn get_max_y(bitmap: u256) -> usize {
        let mut n: usize = 15;
        loop {
            if (n == 0) { break; }
            if (Bitmap::row(bitmap, n) != 0 ) { break; }
            n -= 1;
        };
        n
    }

    fn rotate_north_to(bitmap: u256, dir: Dir) -> u256 {
        // rotate North to...
        match dir {
            Dir::North => bitmap,
            Dir::East => Bitmap::Rotate_90_cw(bitmap),
            Dir::West => Bitmap::Rotate_90_ccw(bitmap),
            Dir::South => Bitmap::Rotate_180(bitmap),
            Dir::Over => bitmap,
            Dir::Under => bitmap,
        }
    }

    fn Rotate_90_cw(bitmap: u256) -> u256 {
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

    fn Rotate_90_ccw(bitmap: u256) -> u256 {
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

    fn Rotate_180(bitmap: u256) -> u256 {
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

fn assert_tile_to_xy(i: usize, x: usize, y: usize) {
    assert(Bitmap::tile_to_xy(i) == (x, y), 'tile_to_xy');
    assert(Bitmap::xy_to_tile(x, y) == i, 'xy_to_tile');
}

#[test]
#[available_gas(100_000_000)]
fn test_bitmap_tile_xy() {
    assert_tile_to_xy(0, 0, 0);
    assert_tile_to_xy(1, 1, 0);
    assert_tile_to_xy(15, 15, 0);
    assert_tile_to_xy(16, 0, 1);
    assert_tile_to_xy(17, 1, 1);
    assert_tile_to_xy(32, 0, 2);
    assert_tile_to_xy(255, 15, 15);
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


#[test]
#[available_gas(1_000_000_000)]
fn test_shift_left_right() {
    let mut bmp = MASK::LEFT_COL;
    assert(Bitmap::shift_right(bmp, 0) == bmp, 'shift_right_zero');
    assert(Bitmap::shift_right(bmp, 16) == 0, 'shift_right_16');
    bmp = Bitmap::shift_right(bmp, 15);
    assert(bmp == MASK::RIGHT_COL, 'shift_left_15');
    assert(Bitmap::shift_left(bmp, 0) == bmp, 'shift_left_zero');
    assert(Bitmap::shift_left(bmp, 16) == 0, 'shift_left_16');
    bmp = Bitmap::shift_left(bmp, 15);
    assert(bmp == MASK::LEFT_COL, 'shift_right_15');
}

#[test]
#[available_gas(1_000_000_000)]
fn test_shift_up_fown() {
    let mut bmp = MASK::TOP_ROW;
    assert(Bitmap::shift_down(bmp, 0) == bmp, 'shift_down_zero');
    assert(Bitmap::shift_down(bmp, 16) == 0, 'shift_down_16');
    bmp = Bitmap::shift_down(bmp, 15);
    assert(bmp == MASK::BOTTOM_ROW, 'shift_down_15');
    assert(Bitmap::shift_up(bmp, 0) == bmp, 'shift_up_zero');
    assert(Bitmap::shift_up(bmp, 16) == 0, 'shift_up_16');
    bmp = Bitmap::shift_up(bmp, 15);
    assert(bmp == MASK::TOP_ROW, 'shift_up_15');
}
