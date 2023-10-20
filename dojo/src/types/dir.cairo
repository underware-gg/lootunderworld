use debug::PrintTrait;
use loot_underworld::models::chamber::{Map};

#[derive(Copy, Drop, Serde, PartialEq)]
enum Dir {
    North,  // 0
    East,   // 1
    West,   // 2
    South,  // 3
    Over,   // 4
    Under,  // 5
}

mod DIR {
    const NORTH: u8 = 0;
    const EAST: u8 = 1;
    const WEST: u8 = 2;
    const SOUTH: u8 = 3;
    const OVER: u8 = 4;
    const UNDER: u8 = 5;
    // dirs count
    const COUNT: u8 = 6;
}

trait DirTrait {
    fn flip(self: Dir) -> Dir;
    fn flip_door_tile(self: Dir, i: u8) -> u8;
    fn door_tile_from_map(self: Dir, map: Map) -> u8;
}

impl DirTraitImpl of DirTrait {
    fn flip(self: Dir) -> Dir {
        match self {
            Dir::North => Dir::South,
            Dir::East  => Dir::West,
            Dir::West  => Dir::East,
            Dir::South => Dir::North,
            Dir::Over  => Dir::Under,
            Dir::Under => Dir::Over,
        }
    }
    fn flip_door_tile(self: Dir, i: u8) -> u8 {
        match self {
            Dir::North => (i + (15 * 16)),  // flip to South
            Dir::East  => (i - 15),         // flip to West
            Dir::West  => (i + 15),         // flip to East
            Dir::South => (i - (15 * 16)),  // flip to North
            Dir::Over  => (i),              // same position
            Dir::Under => (i),              // same position
        }
    }
    fn door_tile_from_map(self: Dir, map: Map) -> u8 {
        match self {
            Dir::North => map.north,
            Dir::East  => map.east,
            Dir::West  => map.west,
            Dir::South => map.south,
            Dir::Over  => map.over,
            Dir::Under => map.under,
        }
    }
}

impl DirIntoU8 of Into<Dir, u8> {
    fn into(self: Dir) -> u8 {
        match self {
            Dir::North => DIR::NORTH,
            Dir::East  => DIR::EAST,
            Dir::West  => DIR::WEST,
            Dir::South => DIR::SOUTH,
            Dir::Over  => DIR::OVER,
            Dir::Under => DIR::UNDER,
        }
    }
}
impl DirIntoU128 of Into<Dir, u128> {
    fn into(self: Dir) -> u128 {
        match self {
            Dir::North => DIR::NORTH.into(),
            Dir::East  => DIR::EAST.into(),
            Dir::West  => DIR::WEST.into(),
            Dir::South => DIR::SOUTH.into(),
            Dir::Over  => DIR::OVER.into(),
            Dir::Under => DIR::UNDER.into(),
        }
    }
}
impl DirIntoFelt252 of Into<Dir, felt252> {
    fn into(self: Dir) -> felt252 {
        match self {
            Dir::North => DIR::NORTH.into(),
            Dir::East  => DIR::EAST.into(),
            Dir::West  => DIR::WEST.into(),
            Dir::South => DIR::SOUTH.into(),
            Dir::Over  => DIR::OVER.into(),
            Dir::Under => DIR::UNDER.into(),
        }
    }
}

impl TryU8IntoDir of TryInto<u8, Dir> {
    fn try_into(self: u8) -> Option<Dir> {
        if self == DIR::NORTH      { Option::Some(Dir::North) }
        else if self == DIR::EAST  { Option::Some(Dir::East) }
        else if self == DIR::WEST  { Option::Some(Dir::West) }
        else if self == DIR::SOUTH { Option::Some(Dir::South) }
        else if self == DIR::OVER  { Option::Some(Dir::Over) }
        else if self == DIR::UNDER { Option::Some(Dir::Under) }
        else { Option::None }
    }
}
impl TryU128IntoDir of TryInto<u128, Dir> {
    fn try_into(self: u128) -> Option<Dir> {
        if self == DIR::NORTH.into()      { Option::Some(Dir::North) }
        else if self == DIR::EAST.into()  { Option::Some(Dir::East) }
        else if self == DIR::WEST.into()  { Option::Some(Dir::West) }
        else if self == DIR::SOUTH.into() { Option::Some(Dir::South) }
        else if self == DIR::OVER.into()  { Option::Some(Dir::Over) }
        else if self == DIR::UNDER.into() { Option::Some(Dir::Under) }
        else { Option::None }
    }
}
impl TryFelt252IntoDir of TryInto<felt252, Dir> {
    fn try_into(self: felt252) -> Option<Dir> {
        if self == DIR::NORTH.into()      { Option::Some(Dir::North) }
        else if self == DIR::EAST.into()  { Option::Some(Dir::East) }
        else if self == DIR::WEST.into()  { Option::Some(Dir::West) }
        else if self == DIR::SOUTH.into() { Option::Some(Dir::South) }
        else if self == DIR::OVER.into()  { Option::Some(Dir::Over) }
        else if self == DIR::UNDER.into() { Option::Some(Dir::Under) }
        else { Option::None }
    }
}

impl PrintDir of PrintTrait<Dir> {
    fn print(self: Dir) {
        let felt: felt252 = self.into();
        felt.print();
    }
}





//------------------------------------------------------------------
// Unit tests
//
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::core::randomizer::{randomize_door_tile};
use loot_underworld::utils::bitmap::{Bitmap};

#[test]
#[available_gas(1_000_000_000)]
fn test_flip_door_tile() {
    let mut rnd = make_seed(777, 888);
    let mut dir_u8: u8 = 0;
    loop {
        if (dir_u8 == DIR::COUNT) { break; }
        // ---
        let maybe_dir: Option<Dir> = dir_u8.try_into();
        let dir: Dir = maybe_dir.unwrap();
        let mut i: usize = 0;
        loop {
            if (i == 5) { break; }
            // ---
            let tile: u8 = randomize_door_tile(ref rnd, dir);
            let (x, y) = Bitmap::tile_to_xy(tile.into());
            let flipped = dir.flip_door_tile(tile);
            let (fx, fy) = Bitmap::tile_to_xy(flipped.into());

            if(x == 0) {
                assert(fx == 15, 'x==0');
                assert(fy == y, 'x==0_y');
            }
            else if(x == 15) {
                assert(fx == 0, 'x==15');
                assert(fy == y, 'x==15_y');
            }
            else {
                assert(fx == x, 'x==fx');
            }

            if(y == 0) {
                assert(fy == 15, 'y==0');
                assert(fx == x, 'y==0_x');
            }
            else if(y == 15) {
                assert(fy == 0, 'y==15');
                assert(fx == x, 'y==15_x');
            }
            else {
                assert(fy == y, 'y==fy');
            }
            
            let unflipped = dir.flip().flip_door_tile(flipped);
            assert(unflipped == tile, 'unflipped==tile');
            let (ffx, ffy) = Bitmap::tile_to_xy(unflipped.into());
            assert(ffx == x, 'x==ffx');
            assert(ffy == y, 'y==ffy');
            // ---
            i += 1;
        };
        // ---
        dir_u8 += 1;
    };
}
