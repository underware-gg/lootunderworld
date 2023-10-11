use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::hash::{hash_u128};
use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::types::dir::{Dir, DIR};

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

//----------------------------
// Generic value randomizer
//

// Hashes rnd.high + rnd.low
// result value is in rnd.low
#[inline(always)]
fn _rnd_rnd_(rnd: u256) -> u256 {
    let value: u128 = hash_u128(rnd.high, rnd.low);
    u256 {
        high: rnd.high,
        low: value,
    }
}

// randomizes a value lower than max (exclusive)
// returns the new rnd and the value
#[inline(always)]
fn randomize_value(ref rnd: u256, max: u128) -> u128 {
    rnd = _rnd_rnd_(rnd);
    (rnd.low % max)
}

// randomizes a value between min .. max (inclusive)
// returns the new rnd and the value
#[inline(always)]
fn randomize_range(ref rnd: u256, min: u128, max: u128) -> u128 {
    rnd = _rnd_rnd_(rnd);
    (min + rnd.low % (max - min + 1))
}
#[inline(always)]
fn randomize_range_usize(ref rnd: u256, min: u128, max: u128) -> usize {
    randomize_range(ref rnd, min, max).try_into().unwrap()
}


//---------------------------
// Attributes randomizer
//

// Returns an u8 with flags if doors positions are permitted to be generated, for all directions
// usage example: U8Bitwise::is_set(permissions, DIR::UNDER.into())
fn randomize_door_permissions(ref rnd: u256) -> u8 {
    // TODO: create some rule here
    return 0xff;
}

// randomize a tile position
fn randomize_tile_pos(ref rnd: u256, bitmap: u256, protected: u256) -> usize {

    // TODO: verify bitmap / protected
    // TODO: + verify tests

    let x : usize = randomize_range_usize(ref rnd, RANGE::TILE::MIN, RANGE::TILE::MAX);
    let y : usize = randomize_range_usize(ref rnd, RANGE::TILE::MIN, RANGE::TILE::MAX);
    Bitmap::xy_to_tile(x, y)
}

// Randomize a door slot attached to a NEWS direction (bitmap border)
fn _randomize_door_slot(ref rnd: u256, dir: Dir) -> usize {
    randomize_range_usize(ref rnd, RANGE::DOOR::MIN, RANGE::DOOR::MAX)
}

// randomize a door position as a tile (Over, Under)
fn randomize_door_pos(ref rnd: u256, dir: Dir) -> u8 {
    match dir {
        Dir::North => Bitmap::xy_to_tile(_randomize_door_slot(ref rnd, dir), 0),
        Dir::East => Bitmap::xy_to_tile(15, _randomize_door_slot(ref rnd, dir)),
        Dir::West => Bitmap::xy_to_tile(0, _randomize_door_slot(ref rnd, dir)),
        Dir::South => Bitmap::xy_to_tile(_randomize_door_slot(ref rnd, dir), 15),
        Dir::Over => randomize_tile_pos(ref rnd, 0x0, 0x0),
        Dir::Under => randomize_tile_pos(ref rnd, 0x0, 0x0),
    }.try_into().unwrap()
}




//------------------------------------------------------------------
// Unit tests
//
use array::ArrayTrait;
use loot_underworld::utils::bitwise::{U8Bitwise};

#[test]
#[available_gas(1000000)]
fn test_hash_randomize_value() {
    let mut rnd = make_seed(111, 222);
    let rnd0 = rnd;
    let val1 = randomize_value(ref rnd, 0xffffffff);
    let rnd1 = rnd;
    assert(rnd0.high == rnd.high, 'rnd.high_1');
    assert(rnd1.low != rnd0.low, 'rnd.low_1');
    let val2 = randomize_value(ref rnd, 0xffffffff);
    let rnd2 = rnd;
    assert(rnd0.high == rnd.high, 'rnd.high_2');
    assert(rnd2.low != rnd1.low, 'rnd.low_2');
    assert(val2 != val1, 'rnd.value_2');
    let val3 = randomize_value(ref rnd, 0xffffffff);
    let rnd3 = rnd;
    assert(rnd0.high == rnd.high, 'rnd.high_3');
    assert(rnd3.low != rnd2.low, 'rnd.low_3');
    assert(val3 != val2, 'rnd.value_3');
    let val4 = randomize_value(ref rnd, 0xffffffff);
    let rnd4 = rnd;
    assert(rnd0.high == rnd.high, 'rnd.high_4');
    assert(rnd4.low != rnd3.low, 'rnd.low_4');
    assert(val4 != val3, 'rnd.value_4');
}

#[test]
#[available_gas(10_000_000)]
fn test_hash_randomize_range() {
    let mut rnd = make_seed(128, 128);
    let mut values: u8 = 0x0;
    let mut i: u128 = 0;
    let mut h: u128 = 0;
    loop {
        if i > 20 { break; }
        h = randomize_range(ref rnd, 2, 2);
        assert(h == 2, 'not == 2');
        h = randomize_range(ref rnd, 2, 5);
        values = U8Bitwise::set(values, h.try_into().unwrap());
        assert(h >= 2, 'not >= 2');
        assert(h <= 5, 'not <= 5');
        i += 1;
    };
    // all values in range should be set!
    assert(U8Bitwise::is_set(values, 2) == true, '!2');
    assert(U8Bitwise::is_set(values, 3) == true, '!3');
    assert(U8Bitwise::is_set(values, 4) == true, '!4');
    assert(U8Bitwise::is_set(values, 5) == true, '!5');
}

#[test]
#[available_gas(100_000_000)]
fn test_randomize_door_slot() {
    let mut dir_u8: u8 = 0;
    loop {
        if (dir_u8 == DIR::COUNT) { break; }
        // ---
        let maybe_dir: Option<Dir> = dir_u8.try_into();
        let dir: Dir = maybe_dir.unwrap();
        let mut i: usize = 0;
        loop {
            if (i == 20) { break; }
            // ---
            let mut rnd = make_seed(1234, i.into());
            let slot: u128 = _randomize_door_slot(ref rnd, dir).into();
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
#[available_gas(100_000_000)]
fn test_randomize_door_pos() {
    let mut dir_u8: u8 = 0;
    loop {
        if (dir_u8 == DIR::COUNT) { break; }
        // ---
        let maybe_dir: Option<Dir> = dir_u8.try_into();
        let dir: Dir = maybe_dir.unwrap();
        let mut i: usize = 0;
        loop {
            if (i == 20) { break; }
            // ---
            let mut rnd = make_seed(1234, i.into());
            let pos: u8 = randomize_door_pos(ref rnd, dir);
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
        let mut rnd = make_seed(1234, i.into());
        let pos: usize = randomize_tile_pos(ref rnd, 0, i.into());
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
