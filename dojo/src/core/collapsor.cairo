use array::ArrayTrait;
use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::bitwise::{U256Bitwise};
use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::utils::arrays::{create_array};
use loot_underworld::core::seeder::{make_seed};

/// @notice Apply Simplified Wave Function Collapse 
/// @param seed The Chamber's seed, used as initial random bitmap
/// @param open_spaces True if the generation rules prefer open spaces
/// @return result The collapsed bitmap
/// @dev inspired by:
/// https://www.youtube.com/watch?v=rI_y2GAlQFM
/// https://github.com/mxgmn/WaveFunctionCollapse (MIT)
fn collapse(seed: u256, open_spaces: bool) -> u256 {
    // final cells size will be 64
    let mut cells: Array::<u8> = ArrayTrait::new();

    let mut i: u8 = 0;
    loop {
        if i >= 64 { break; }

        let x: u8 = (i % 8).into();
        let y: u8 = (i / 8).into();
        let mut left: u8 = 255;
        let mut up: u8 = 255;
        if x > 0 {
            left = *cells[((y * 8) + x - 1).into()];
        }
        if y > 0 {
            up = *cells[(((y - 1) * 8) + x).into()];
        }

        // each cell is 4 bits (2x2)
        let mut cell: u8 = 0;

        // bit 1: 1000 (0x08)
        // - is left[1] set?
        // - is up[2] set?
        // - else random
        if (left != 255) {
            if (left & 0x04 != 0) {
                cell = cell | 0x08
            }
        } else if (up != 255) {
            if (up & 0x02 != 0) {
                cell = cell | 0x08;
            }
        } else if U256Bitwise::is_set(seed, (i*4).into()) {
            cell = cell | 0x08;
        }
        // bit 2: 0100 (0x04)
        // - is up[3] set?
        // - else random
        if (up != 255) {
            if (up & 0x01 != 0) {
                cell = cell | 0x04;
            }
        } else if U256Bitwise::is_set(seed, (i*4+1).into()) {
            cell = cell | 0x04;
        }
        // bit 3: 0010 (0x02)
        // - is left[3] set?
        // - else random
        if (left != 255) {
            if (left & 0x01 != 0) {
                cell = cell | 0x02;
            }
        } else if U256Bitwise::is_set(seed, (i*4+2).into()) {
            cell = cell | 0x02;
        }
        // bit 4: 0001 (0x01)
        // - always random
        if U256Bitwise::is_set(seed, (i*4+3).into()) {
            cell = cell | 0x01;
        }

        //
        // avoid checkers pattern
        // (for more connected rooms)
        //
        // if 0110 (0x06), replace by:
        // 1111 (0x0f) if open_spaces, or 1110 (0x0e) or 0111 (0x07)
        if (cell == 0x06) {
            if open_spaces {
                cell = 0x0f;
            } else if U256Bitwise::is_set(seed, (i*4).into()) {
                cell = 0x0e;
            } else {
                cell = 0x07;
            }
        }
        // if 1001 (0x09), replace by:
        // 1111 (0x0f) if open_spaces, or 1101 (0x0d) or 1011 (0x0b)
        if (cell == 0x09) {
            if open_spaces {
                cell = 0x0f;
            } else if U256Bitwise::is_set(seed, (i*4).into()) {
                cell = 0x0d;
            } else {
                cell = 0x0b;
            }
        }

        cells.append(cell);

        i += 1;
    };

    // print cells into bitmap
    let mut result: u256 = 0;
    let mut i: usize = 0;
    loop {
        if i >= 64 { break; }
        let x = (i % 8) * 2;
        let y = (i / 8) * 2;
        if (*cells[i] & 0x08 != 0) {
            result = Bitmap::set_xy(result, x, y);
        }
        if (*cells[i] & 0x04 != 0) {
            result = Bitmap::set_xy(result, x + 1, y);
        }
        if (*cells[i] & 0x02 != 0) {
            result = Bitmap::set_xy(result, x, y + 1);
        }
        if (*cells[i] & 0x01 != 0) {
            result = Bitmap::set_xy(result, x + 1, y + 1);
        }
        i += 1;
    };

    result
}


#[test]
#[available_gas(50_000_000)]
fn test_collapse() {
    let seed = make_seed(1234, 5678);
    let bitmap = collapse(seed, false);
    assert(seed != bitmap, '');
}
