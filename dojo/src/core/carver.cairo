use array::ArrayTrait;
use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::bitwise::{U256Bitwise};
use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::utils::arrays::{create_array};
use loot_underworld::core::seeder::{make_seed};

const CELL_VALUE_WALL: u8 = 0x01;
const CELL_VALUE_PROTECTED: u8 = 0x04;

fn calc_cell_values(bitmap: u256, protected: u256) -> Array::<u8> {
    // let mut result: Array::<u8> = create_array(256, 0_u8);
    let mut result: Array::<u8> = ArrayTrait::new();
    let mut i: usize = 0;
    loop {
        if (i >= 256) { break; }
        let bit: u256 = U256Bitwise::bit(255 - i);
        if (protected & bit) != 0 {
            result.append(CELL_VALUE_PROTECTED);
        } else if (bitmap & bit) != 0 {
            result.append(CELL_VALUE_WALL);
        } else {
            result.append(0);
        }
        i += 1;
    };
    result
}

/// @notice Apply Simplified Cellular Automata Cave Generator over a bitmap
/// @param bitmap The original bitmap
/// @param protected Bitmap of protected tiles (doors, etc)
/// @param pass_value Minimum neighbour sum value for a bit to remain on
/// @return result The carved bitmap
/// @dev inspired by:
// http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
fn carve(bitmap: u256, protected: u256, pass_value: u8) -> u256 {
    let mut cell_values = calc_cell_values(bitmap, protected);
    let mut result: u256 = 0;
    let mut i: usize = 0;
    loop {
        if i >= 256 { break; }
        let x = (i % 16);
        let y = (i / 16);
        let mut area_count: u8 = *cell_values[i] * 2;
        if (y > 0) {
            area_count += *cell_values[i-16]; // x, y-1
        }
        if (y < 15) {
            area_count += *cell_values[i+16]; // x, y+1
        }
        if (x > 0) {
            area_count += *cell_values[i-1]; // x-1, y
            if y > 0 {
                area_count += *cell_values[i-16-1]; // x-1, y-1
            }
            if y < 15 {
                area_count += *cell_values[i+16-1]; // x-1, y+1
            }
        }
        if (x < 15) {
            area_count += *cell_values[i+1]; // x+1, y
            if y > 0 {
                area_count += *cell_values[i-16+1]; // x+, y-1
            }
            if y < 15 {
                area_count += *cell_values[i+16+1]; // x+1, y+1
            }
        }
        // apply rule
        if (area_count >= pass_value) {
            result = Bitmap::set_xy(result, x, y); // set bit
        }
        i += 1;
    };
    result
}


//----------------------------------------------
// test_calc_cell_values
//
use integer::BoundedU256;

#[test]
#[available_gas(20_000_000)]
fn test_calc_cell_values() {
    let values = calc_cell_values(0xff, 0x0f);
    let mut n: usize = 0;
    loop {
        if (n < 4) {
            assert(*values[255 - n] == CELL_VALUE_PROTECTED, 'test_calc_cell_values PROTECTED');
        } else if (n < 8) {
            assert(*values[255 - n] == CELL_VALUE_WALL, 'test_calc_cell_values WALL');
        } else {
            assert(*values[255 - n] == 0, 'test_calc_cell_values PATH');
        }
        if (n == 255) { break; }
        n += 1;
    }
}

#[test]
#[available_gas(20_000_000)]
fn test_calc_cell_values_max() {
    let values = calc_cell_values(BoundedU256::max(), BoundedU256::max());
    let mut n: usize = 0;
    loop {
        assert(*values[n] == CELL_VALUE_PROTECTED, 'test_calc_cell_values PATH');
        if (n == 255) { break; }
        n += 1;
    }
}

#[test]
#[available_gas(60_000_000)]
fn test_carve() {
    let seed = make_seed(1234, 5678);
    let bitmap = carve(seed, 0, 5);
    assert(seed != bitmap, '');
}
