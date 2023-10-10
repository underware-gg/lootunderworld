use loot_underworld::core::seeder::{make_underseed, make_overseed};
use loot_underworld::core::carver::{carve};
use loot_underworld::core::protector::{protect};
use loot_underworld::utils::bitwise::{U256Bitwise};
use loot_underworld::utils::bitmap::{Bitmap, MASK};
use loot_underworld::types::dir::{Dir, DirTrait, DIR};
use debug::PrintTrait;


fn connect_doors(seed: u256, protected: u256, entry_dir: Dir, style: u128) -> (u256, u256) {
    let mut res_bitmap: u256 = 0;
    let mut res_protected: u256 = protected;

    // doors ranges
    let (min_x, max_x): (usize, usize) = Bitmap::get_range_x(protected & MASK::OUTER_ROWS);
    let (min_y, max_y): (usize, usize) = Bitmap::get_range_y(protected & MASK::OUTER_COLS);

    let mut dir: u8 = entry_dir.into();
    let mut src: u256 = 0;
    let mut n: usize = 0;

    // copy north down
    src = protected & MASK::TOP_ROW;
    n = 1;
    loop {
        if (n > max_y) { break; }
        src = Bitmap::shift_down(src, 1);
        if(dir != DIR::NORTH && dir != DIR::SOUTH) {
            src = src | Bitmap::row(protected & MASK::INNER, n); // add current row
        }
        res_protected = res_protected | src;
        n += 1;
    };

    // copy south up
    src = protected & MASK::BOTTOM_ROW;
    n = 14;
    loop {
        if (n < min_y) { break; }
        src = Bitmap::shift_up(src, 1);
        if(dir != DIR::NORTH && dir != DIR::SOUTH) {
            src = src | Bitmap::row(protected & MASK::INNER, n); // add current row
        }
        res_protected = res_protected | src;
        n -= 1;
    };

    // copy west > right
    src = protected & MASK::LEFT_COL;
    n = 1;
    loop {
        if (n > max_x) { break; }
        src = Bitmap::shift_right(src, 1);
        if(dir != DIR::WEST && dir != DIR::EAST) {
            src = src | Bitmap::column(protected & MASK::INNER, n); // add current col
        }
        res_protected = res_protected | src;
        n += 1;
    };

    // copy east < left
    src = protected & MASK::RIGHT_COL;
    n = 14;
    loop {
        if (n < min_x) { break; }
        src = Bitmap::shift_left(src, 1);
        if(dir != DIR::WEST && dir != DIR::EAST) {
            src = src | Bitmap::column(protected & MASK::INNER, n); // add current col
        }
        res_protected = res_protected | src;
        n -= 1;
    };

    if(style == 0) {
        // thin corridors
        res_bitmap = protect(0, protected);
        res_bitmap = res_bitmap | res_protected;
    } else if(style == 1) {
        // large corridors
        res_bitmap = protect(0, res_protected);
    } else if(style == 2) {
        // carved
        res_bitmap = protect(0, res_protected);
        res_bitmap = carve(res_bitmap, res_protected, 5);
    }

    (res_bitmap, res_protected)
}