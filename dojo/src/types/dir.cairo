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

trait DirTrait {
    fn flip(self: Dir) -> Dir;
}

impl DirFlipImpl of DirTrait {
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
            Dir::North => 0,
            Dir::East => 1,
            Dir::West => 2,
            Dir::South => 3,
            Dir::Over => 4,
            Dir::Under => 5,
        }
    }
}
impl TryU8IntoDir of TryInto<u8, Dir> {
    fn try_into(self: u8) -> Option<Dir> {
        if self == 0 {
            Option::Some(Dir::North)
        } else if self == 1 {
            Option::Some(Dir::East)
        } else if self == 2 {
            Option::Some(Dir::West)
        } else if self == 3 {
            Option::Some(Dir::South)
        } else if self == 4 {
            Option::Some(Dir::Over)
        } else if self == 5 {
            Option::Some(Dir::Under)
        } else {
            Option::None
        }
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
        if self == 'North' {
            Option::Some(Dir::North)
        } else if self == 'East' {
            Option::Some(Dir::East)
        } else if self == 'West' {
            Option::Some(Dir::West)
        } else if self == 'South' {
            Option::Some(Dir::South)
        } else if self == 'Over' {
            Option::Some(Dir::Over)
        } else if self == 'Under' {
            Option::Some(Dir::Under)
        } else {
            Option::None
        }
    }
}

impl PrintDir of PrintTrait<Dir> {
    fn print(self: Dir) {
        let felt: felt252 = self.into();
        felt.print();
    }
}
