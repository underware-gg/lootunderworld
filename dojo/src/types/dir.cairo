use debug::PrintTrait;

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
}

impl DirTraitImpl of DirTrait {
    fn flip(self: Dir) -> Dir {
        match self {
            Dir::North => Dir::South,
            Dir::East => Dir::West,
            Dir::West => Dir::East,
            Dir::South => Dir::North,
            Dir::Over => Dir::Under,
            Dir::Under => Dir::Over,
        }
    }
}

impl DirIntoU8 of Into<Dir, u8> {
    fn into(self: Dir) -> u8 {
        match self {
            Dir::North => DIR::NORTH,
            Dir::East => DIR::EAST,
            Dir::West => DIR::WEST,
            Dir::South => DIR::SOUTH,
            Dir::Over => DIR::OVER,
            Dir::Under => DIR::UNDER,
        }
    }
}
impl DirIntoU128 of Into<Dir, u128> {
    fn into(self: Dir) -> u128 {
        match self {
            Dir::North => DIR::NORTH.into(),
            Dir::East => DIR::EAST.into(),
            Dir::West => DIR::WEST.into(),
            Dir::South => DIR::SOUTH.into(),
            Dir::Over => DIR::OVER.into(),
            Dir::Under => DIR::UNDER.into(),
        }
    }
}

impl TryU8IntoDir of TryInto<u8, Dir> {
    fn try_into(self: u8) -> Option<Dir> {
        if self == DIR::NORTH { Option::Some(Dir::North) }
        else if self == DIR::EAST { Option::Some(Dir::East) }
        else if self == DIR::WEST { Option::Some(Dir::West) }
        else if self == DIR::SOUTH { Option::Some(Dir::South) }
        else if self == DIR::OVER { Option::Some(Dir::Over) }
        else if self == DIR::UNDER { Option::Some(Dir::Under) }
        else { Option::None }
    }
}
impl TryU128IntoDir of TryInto<u128, Dir> {
    fn try_into(self: u128) -> Option<Dir> {
        if self == DIR::NORTH.into() { Option::Some(Dir::North) }
        else if self == DIR::EAST.into() { Option::Some(Dir::East) }
        else if self == DIR::WEST.into() { Option::Some(Dir::West) }
        else if self == DIR::SOUTH.into() { Option::Some(Dir::South) }
        else if self == DIR::OVER.into() { Option::Some(Dir::Over) }
        else if self == DIR::UNDER.into() { Option::Some(Dir::Under) }
        else { Option::None }
    }
}

impl DirIntoFelt252 of Into<Dir, felt252> {
    fn into(self: Dir) -> felt252 {
        match self {
            Dir::North => 'North',
            Dir::East => 'East',
            Dir::West => 'West',
            Dir::South => 'South',
            Dir::Over => 'Over',
            Dir::Under => 'Under',
        }
    }
}
impl TryFelt252IntoDir of TryInto<felt252, Dir> {
    fn try_into(self: felt252) -> Option<Dir> {
        if self == 'North' { Option::Some(Dir::North) }
        else if self == 'East' { Option::Some(Dir::East) }
        else if self == 'West' { Option::Some(Dir::West) }
        else if self == 'South' { Option::Some(Dir::South) }
        else if self == 'Over' { Option::Some(Dir::Over) }
        else if self == 'Under' { Option::Some(Dir::Under) }
        else { Option::None }
    }
}

impl PrintDir of PrintTrait<Dir> {
    fn print(self: Dir) {
        let felt: felt252 = self.into();
        felt.print();
    }
}
