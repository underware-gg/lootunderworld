use loot_underworld::core::seeder::{make_underseed, make_overseed};
use loot_underworld::core::carver::{carve};
use loot_underworld::core::protector::{protect};
use loot_underworld::utils::bitwise::{U256Bitwise};
use loot_underworld::utils::bitmap::{Bitmap, MASK};
use loot_underworld::types::dir::{Dir, DirTrait, DIR};
use debug::PrintTrait;


fn connect_doors(seed: u256, protected: u256, entry_dir: Dir, style: u32) -> u256 {
    let mut bitmap: u256 = 0;
    let mut corridors: u256 = protected;

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
        corridors = corridors | src;
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
        corridors = corridors | src;
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
        corridors = corridors | src;
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
        corridors = corridors | src;
        n -= 1;
    };

    if(style == 0) {
        // thin corridors
        bitmap = corridors | protect(0, protected);
    } else if(style == 1) {
        // large corridors
        bitmap = protect(0, corridors);
    } else if(style == 2) {
        // carved
        bitmap = protect(0, corridors);
        bitmap = carve(bitmap, corridors, 5);
    }

    (bitmap)
}