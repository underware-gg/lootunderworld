use array::ArrayTrait;
use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::hash::{hash_u128, hash_u128_to_u256};
use loot_underworld::utils::arrays::{create_array};
use loot_underworld::utils::bitshift::{U256BitShift};
use loot_underworld::core::seeder::{make_seed};

const CELL_VALUE_WALL: u8 = 0x01;
const CELL_VALUE_PROTECTED: u8 = 0x04;

fn get_cell_values(bitmap: u256, protected: u256) -> Array::<u8> {
    // let mut result: Array::<u8> = create_array(256, 0_u8);
    let mut result: Array::<u8> = ArrayTrait::new();
    let mut i: u256 = 0;
    loop {
        if i >= 256 { break; }
        let mut cell_value: u8 = 0;
        let bit = U256BitShift::bit(i);
        if (protected & bit != 0) {
            cell_value += CELL_VALUE_PROTECTED;
        } else if (bitmap & bit != 0) {
            cell_value += CELL_VALUE_WALL;
        }
        result.append(cell_value);
        i += 1;
    };
    result
}

fn carve(bitmap: u256, protected: u256, pass_value: u8) -> u256 {
    let mut cell_values = get_cell_values(bitmap, protected);
    let mut result: u256 = bitmap;
    let mut i: usize = 0;
    loop {
        if i >= 256 { break; }
        let x = (i % 16);
        let y = (i / 16);
        let mut area_count: u8 = *cell_values.at(i) * 2;
        if(y > 0) {
            area_count += *cell_values.at(i-16); // x, y-1
        }
        if(y < 15) {
            area_count += *cell_values.at(i+16); // x, y+1
        }
        if x > 0 {
            area_count += *cell_values.at(i-1); // x-1, y
            if y > 0 {
                area_count += *cell_values.at(i-16-1); // x-1, y-1
            }
            if y < 15 {
                area_count += *cell_values.at(i+16-1); // x-1, y+1
            }
        }
        if x < 15 {
            area_count += *cell_values.at(i+1); // x+1, y
            if y > 0 {
                area_count += *cell_values.at(i-16+1); // x+, y-1
            }
            if y < 15 {
                area_count += *cell_values.at(i+16+1); // x+1, y+1
            }
        }
        // apply rule
        if area_count >= pass_value {
            result = result | U256BitShift::bit((255 - i).into()); // set bit
        }
        i += 1;
    };
    result
}



#[test]
#[available_gas(10_000_000_000)]
fn test_get_cell_values() {
    let values = get_cell_values(0xff, 0x0f);
    let mut n: usize = 255;
    loop {
        if n < 4 {
            assert(*values.at(n) == CELL_VALUE_PROTECTED, 'test_get_cell_values PROTECTED');
        } else if n < 8 {
            assert(*values.at(n) == CELL_VALUE_WALL, 'test_get_cell_values WALL');
        } else {
            assert(*values.at(n) == 0, 'test_get_cell_values PATH');
        }
        if n == 0 { break; }
        n -= 1;
    };
}

#[test]
#[available_gas(10_000_000_000)]
fn test_carve() {
    let seed = make_seed(987329842, 2374293482);
    let bitmap = carve(seed, 0, 5);
    assert(seed != bitmap, '');
}
