use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::hash::{hash_128_range};
use loot_underworld::types::dir::{Dir};

const DOOR_OFFSET: u128 = 0;

// Randomize a door slot attached to a NEWS direction (bitmap border)
// ....xxxxxxxx....
fn randomize_door_slot(seed: u256, dir: u8) -> u8 {
    hash_128_range(seed.low, DOOR_OFFSET + dir.into(), 4, 11).try_into().unwrap()
}

// randomize a door position as a tile (Over, Under)
fn randomize_door_pos(seed: u256, dir: u8) -> u8 {
    randomize_tile_pos(seed, 0x0, DOOR_OFFSET + dir.into())
}

// randomize a tile position
// ..xxxxxxxxxxxx..
fn randomize_tile_pos(seed: u256, bitmap: u256, offset: u128) -> u8 {
    let x: u8 = hash_128_range(seed.low, offset, 2, 13).try_into().unwrap();
    let y: u8 = hash_128_range(seed.high, offset, 2, 13).try_into().unwrap();
    (y * 16 + x)
}



#[test]
#[available_gas(100_000)]
fn test_randomize_door_slot() {
    assert(true == false, 'TODO: test_randomize_door_slot');
}

#[test]
#[available_gas(100_000)]
fn test_randomize_door_pos() {
    assert(true == false, 'TODO: randomize_door_pos');
}

#[test]
#[available_gas(100_000)]
fn test_randomize_tile_pos() {
    assert(true == false, 'TODO: test_randomize_tile_pos');
}
