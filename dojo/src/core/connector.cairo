use loot_underworld::core::carver::{carve};
use loot_underworld::core::protector::{protect};
use loot_underworld::core::randomizer::{RANGE};
use loot_underworld::utils::bitmap::{Bitmap, MASK};
use loot_underworld::types::dir::{Dir};
// use debug::PrintTrait;

fn connect_doors(protected: u256, entry_dir: Dir, style: u32) -> u256 {
    let mut bitmap: u256 = 0;
    let mut corridors: u256 = protected;

    // doors ranges
    let (min_x, max_x, min_y, max_y): (usize, usize, usize, usize) = get_doors_range(ref corridors, protected);

    // stretch north door > south
    let inner = protected & MASK::INNER;
    let mut src = protected & MASK::TOP_ROW;
    let mut n = 1;
    loop {
        if (n > max_y) { break; }
        src = Bitmap::shift_down(src, 1);
        if(inner != 0 && entry_dir != Dir::North && entry_dir != Dir::South) {
            src = src | Bitmap::row(inner, n); // add current row
        }
        corridors = corridors | src;
        n += 1;
    };

    // stretch south door > north
    src = protected & MASK::BOTTOM_ROW;
    n = 14;
    loop {
        if (n < min_y) { break; }
        src = Bitmap::shift_up(src, 1);
        if(inner != 0 && entry_dir != Dir::North && entry_dir != Dir::South) {
            src = src | Bitmap::row(inner, n); // add current row
        }
        corridors = corridors | src;
        n -= 1;
    };

    // stretch west door > east
    src = protected & MASK::LEFT_COL;
    n = 1;
    loop {
        if (n > max_x) { break; }
        src = Bitmap::shift_right(src, 1);
        if(inner != 0 && entry_dir != Dir::East && entry_dir != Dir::West) {
            src = src | Bitmap::column(inner, n); // add current col
        }
        corridors = corridors | src;
        n += 1;
    };

    // stretch east door > west
    src = protected & MASK::RIGHT_COL;
    n = 14;
    loop {
        if (n < min_x) { break; }
        src = Bitmap::shift_left(src, 1);
        if(inner != 0 && entry_dir != Dir::East && entry_dir != Dir::West) {
            src = src | Bitmap::column(inner, n); // add current col
        }
        corridors = corridors | src;
        n -= 1;
    };

    if(style == 0) {
        // narrow corridors
        bitmap = corridors | protect(0, protected);
    } else if(style == 1) {
        // wide corridors
        bitmap = protect(0, corridors);
    } else if(style >= 2) {
        let pass: u8 =
            if (style == 2) { 5 } // carved
            else {3};             // wider carved
        bitmap = protect(0, corridors);
        bitmap = carve(bitmap, corridors, pass);
    }

    (bitmap)
}

// Breaking down ONLY to avoid the 'Attempted to merge branches with different bases to align' bug
fn get_doors_range(ref corridors: u256, protected: u256) -> (usize, usize, usize, usize) {
    // doors ranges
    let (mut min_x, mut max_x): (usize, usize) = Bitmap::get_range_x(protected & MASK::INNER_COLS);
    let (mut min_y, mut max_y): (usize, usize) = Bitmap::get_range_y(protected & MASK::INNER_ROWS);

    // nothing in the X range, randomize a center
    if (max_x == 0) {
        min_x = (RANGE::DOOR::MIN + ((protected.low | protected.high) % RANGE::DOOR::SIZE)).try_into().unwrap();
        max_x = min_x;

        // connect east-west corridors
        let mut y = min_y + 1;
        loop {
            if (y >= max_y) { break; }
            corridors = Bitmap::set_xy(corridors, min_x, y);
            y += 1;
        };
    }

    // nothing in the Y range, randomize a center
    if (max_y == 0) {
        min_y = (RANGE::DOOR::MIN + ((protected.low | protected.high) % RANGE::DOOR::SIZE)).try_into().unwrap();
        max_y = min_y;

        // connect north-south corridors
        let mut x = min_x + 1;
        loop {
            if (x >= max_x) { break; }
            corridors = Bitmap::set_xy(corridors, x, min_y);
            x += 1;
        };
    }

    (min_x, max_x, min_y, max_y)
}

