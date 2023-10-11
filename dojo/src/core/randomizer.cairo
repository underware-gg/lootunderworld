use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::hash::{hash_128_range};
use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::types::dir::{Dir, DIR};

// seed offsets
const DOOR_OFFSET: u128 = 0;

// tile ranges
mod RANGE {
    mod DOOR {
        // ....xxxxxxxx....
        const MIN: u128 = 4;
        const MAX: u128 = 11;
    }
    mod TILE {
        // ..xxxxxxxxxxxx..
        const MIN: u128 = 2;
        const MAX: u128 = 13;
    }
}

// Randomize a door slot attached to a NEWS direction (bitmap border)
fn randomize_door_slot(seed: u256, dir: Dir) -> usize {
    hash_128_range(seed.low, DOOR_OFFSET + dir.into(), RANGE::DOOR::MIN, RANGE::DOOR::MAX).try_into().unwrap()
}

// randomize a door position as a tile (Over, Under)
fn randomize_door_pos(seed: u256, dir: Dir) -> u8 {
    let result: usize = match dir {
        Dir::North => Bitmap::xy_to_tile(randomize_door_slot(seed, dir), 0),
        Dir::East => Bitmap::xy_to_tile(15, randomize_door_slot(seed, dir)),
        Dir::West => Bitmap::xy_to_tile(0, randomize_door_slot(seed, dir)),
        Dir::South => Bitmap::xy_to_tile(randomize_door_slot(seed, dir), 15),
        Dir::Over => randomize_tile_pos(seed, 0x0, 0x0, DOOR_OFFSET + dir.into()),
        Dir::Under => randomize_tile_pos(seed, 0x0, 0x0, DOOR_OFFSET + dir.into()),
    };
    result.try_into().unwrap()
}

fn randomize_under_passage(seed: u256) -> bool {
    // TODO: create some rule here
    return true;
}

// randomize a tile position
fn randomize_tile_pos(seed: u256, bitmap: u256, protected: u256, offset: u128) -> usize {

    // TODO: verify bitmap / protected
    // TODO: + verify tests

    let x: usize = hash_128_range(seed.low, offset, RANGE::TILE::MIN, RANGE::TILE::MAX).try_into().unwrap();
    let y: usize = hash_128_range(seed.high, offset, RANGE::TILE::MIN, RANGE::TILE::MAX).try_into().unwrap();
    Bitmap::xy_to_tile(x, y)
}




//------------------------------------------------------------------
// Unit tests
//

#[test]
#[available_gas(10_000_000)]
fn test_randomize_door_slot() {
    let mut dir_u8: u8 = 0;
    loop {
        if (dir_u8 == DIR::COUNT) { break; }
        // ---
        let maybe_dir: Option<Dir> = dir_u8.try_into();
        let dir: Dir = maybe_dir.unwrap();
        let mut i: usize = 0;
        loop {
            if (i == 10) { break; }
            // ---
            let seed = make_seed(1234, i.into());
            let slot: u128 = randomize_door_slot(seed, dir).into();
            assert(slot >= RANGE::DOOR::MIN, 'slot >= min');
            assert(slot <= RANGE::DOOR::MAX, 'slot <= max');
            // ---
            i += 1;
        };
        // ---
        dir_u8 += 1;
    };
}

#[test]
#[available_gas(10_000_000)]
fn test_randomize_door_pos() {
    let mut dir_u8: u8 = 0;
    loop {
        if (dir_u8 == DIR::COUNT) { break; }
        // ---
        let maybe_dir: Option<Dir> = dir_u8.try_into();
        let dir: Dir = maybe_dir.unwrap();
        let mut i: usize = 0;
        loop {
            if (i == 10) { break; }
            // ---
            let seed = make_seed(1234, i.into());
            let pos: u8 = randomize_door_pos(seed, dir);
            let x: u128 = (pos % 16).into();
            let y: u128 = (pos / 16).into();
            if(dir_u8 == DIR::NORTH) {
                assert(y == 0, 'north: y');
                assert(x >= RANGE::DOOR::MIN, 'north: x >= min');
                assert(x <= RANGE::DOOR::MAX, 'north: x <= max');
            } else if(dir_u8 == DIR::EAST) {
                assert(x == 15, 'east: x');
                assert(y >= RANGE::DOOR::MIN, 'east: y >= min');
                assert(y <= RANGE::DOOR::MAX, 'east: y <= max');
            } else if(dir_u8 == DIR::WEST) {
                assert(x == 0, 'west: x');
                assert(y >= RANGE::DOOR::MIN, 'west: y >= min');
                assert(y <= RANGE::DOOR::MAX, 'west: y <= max');
            } else if(dir_u8 == DIR::SOUTH) {
                assert(y == 15, 'south: y');
                assert(x >= RANGE::DOOR::MIN, 'south: x >= min');
                assert(x <= RANGE::DOOR::MAX, 'south: x <= max');
            } else {
                assert(x >= RANGE::TILE::MIN, 'x >= min');
                assert(x <= RANGE::TILE::MAX, 'x <= max');
                assert(y >= RANGE::TILE::MIN, 'y >= min');
                assert(y <= RANGE::TILE::MAX, 'y <= max');
            }
            // ---
            i += 1;
        };
        // ---
        dir_u8 += 1;
    };

}

#[test]
#[available_gas(10_000_000)]
fn test_randomize_tile_pos() {
    let mut i: usize = 0;
    loop {
        if (i == 10) { break; }
        // ---
        let seed = make_seed(1234, i.into());
        let pos: usize = randomize_tile_pos(seed, 0, 0, i.into());
        let x: u128 = (pos % 16).into();
        let y: u128 = (pos / 16).into();
        assert(x >= RANGE::TILE::MIN, 'x >= min');
        assert(x <= RANGE::TILE::MAX, 'x <= max');
        assert(y >= RANGE::TILE::MIN, 'y >= min');
        assert(y <= RANGE::TILE::MAX, 'y <= max');
        // ---
        i += 1;
    };
}
