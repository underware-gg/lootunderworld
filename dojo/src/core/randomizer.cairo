use traits::Into;
use debug::PrintTrait;
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::utils::hash::{hash_u128};
use loot_underworld::utils::bitwise::{U8Bitwise};
use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir, DIR};

// tile ranges
mod RANGE {
    mod DOOR {
        // ....xxxxxxxx....
        const MIN: u128 = 4;
        const MAX: u128 = 11;
        const SIZE: u128 = 8;
    }
    mod TILE {
        // ..xxxxxxxxxxxx..
        const MIN: u128 = 2;
        const MAX: u128 = 13;
        const SIZE: u128 = 12;
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
#[inline(always)]
fn randomize_value_usize(ref rnd: u256, max: u128) -> usize {
    randomize_value(ref rnd, max).try_into().unwrap()
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

// randomize a tile position
fn randomize_game_tile(ref rnd: u256, bitmap: u256, protected: u256) -> usize {

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
fn randomize_door_tile(ref rnd: u256, dir: Dir) -> u8 {
    match dir {
        Dir::North => Bitmap::xy_to_tile(_randomize_door_slot(ref rnd, dir), 0),
        Dir::East => Bitmap::xy_to_tile(15, _randomize_door_slot(ref rnd, dir)),
        Dir::West => Bitmap::xy_to_tile(0, _randomize_door_slot(ref rnd, dir)),
        Dir::South => Bitmap::xy_to_tile(_randomize_door_slot(ref rnd, dir), 15),
        Dir::Over => randomize_game_tile(ref rnd, 0x0, 0x0),
        Dir::Under => randomize_game_tile(ref rnd, 0x0, 0x0),
    }.try_into().unwrap()
}


// North    0b000001
// East     0b000010
// West     0b000100
// South    0b001000
// Over     0b010000
// Under    0b100000
// Returns an u8 with flags if doors positions are permitted to be generated, for all directions
// usage example: U8Bitwise::is_set(permissions, DIR::UNDER.into())
fn randomize_door_permissions(ref rnd: u256, chamber_location: Location, entry_dir: Dir, yonder: u16, generator_name: felt252) -> u8 {
    // seed generator is used for #[test]
    if (generator_name == 'seed') {
        return 0xff;
    }

    // Dir::Over is never permitted!
    let mut result: u8 = 0x0;

    let is_entry: bool = (yonder == 1);

    // Dir::Under
    if (!is_entry && yonder % 3 == 0) {
        result = U8Bitwise::set(result, DIR::UNDER.into());
    }

    // dead end
    let is_dead_end: bool = (
        generator_name != 'connection'
        && false // TODO: this!
    );

    // exit_map 
    // a 3-bit map with all possible exits, not including the entry
    // from 0b000 to 0b111, seven possibilities...
    // (3 one-exit, 3 two-exits, 1 three-exits)
    // plus another bit (0b1000) if the entry is Over
    let exit_map: u8 = if is_dead_end { 0 } else { 0b1000 | randomize_range(ref rnd, 1, 7).try_into().unwrap() };

    // NEWS
    if (exit_map > 0) {
        let mut i: usize = 0;
        if (is_entry || U8Bitwise::is_set(exit_map, i)) {
            result = U8Bitwise::set(result, DIR::NORTH.into());
        }
        if (entry_dir != Dir::North) { i += 1; }
        if (is_entry || U8Bitwise::is_set(exit_map, i)) {
            result = U8Bitwise::set(result, DIR::EAST.into());
        }
        if (entry_dir != Dir::East) { i += 1; }
        if (is_entry || U8Bitwise::is_set(exit_map, i)) {
            result = U8Bitwise::set(result, DIR::WEST.into());
        }
        if (entry_dir != Dir::West) { i += 1; }
        if (is_entry || U8Bitwise::is_set(exit_map, i)) {
            result = U8Bitwise::set(result, DIR::SOUTH.into());
        }
    }

    // (result & 0b110000) | 0b000110 // test east-west connection
    // (result & 0b110000) | 0b001001 // test north-south connection
    (result)
}



//------------------------------------------------------------------
// Unit tests
//
use array::ArrayTrait;

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
    // below max
    let mut values: u8 = 0x0;
    let mut i: u128 = 0;
    loop {
        if i > 20 { break; }
        let h = randomize_value(ref rnd, 4);
        assert(h < 4, 'not < 4');
        values = U8Bitwise::set(values, h.try_into().unwrap());
        i += 1;
    };
    // all values under max should be set!
    assert(U8Bitwise::is_set(values, 0) == true, '!0');
    assert(U8Bitwise::is_set(values, 1) == true, '!1');
    assert(U8Bitwise::is_set(values, 2) == true, '!2');
    assert(U8Bitwise::is_set(values, 3) == true, '!3');
}

#[test]
#[available_gas(10_000_000)]
fn test_hash_randomize_range() {
    let mut rnd = make_seed(128, 128);
    let mut values: u8 = 0x0;
    let mut i: u128 = 0;
    loop {
        if i > 20 { break; }
        let mut h = randomize_range(ref rnd, 2, 2);
        assert(h == 2, 'not == 2');
        h = randomize_range(ref rnd, 2, 5);
        assert(h >= 2, 'not >= 2');
        assert(h <= 5, 'not <= 5');
        values = U8Bitwise::set(values, h.try_into().unwrap());
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
fn test_randomize_door_tile() {
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
            let pos: u8 = randomize_door_tile(ref rnd, dir);
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
fn test_randomize_game_tile() {
    let mut i: usize = 0;
    loop {
        if (i == 10) { break; }
        // ---
        let mut rnd = make_seed(1234, i.into());
        let pos: usize = randomize_game_tile(ref rnd, 0, i.into());
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
