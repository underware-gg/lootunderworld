use debug::PrintTrait;

#[derive(Copy, Drop, Serde, PartialEq)]
enum TileType {
    // --- Endless Crawler Chapter 1
    Void,       // 0
    Entry,      // 1
    Exit,       // 2
    LockedExit, // 3
    Gem,        // 4
    // --- New to Loot Underworld
    // ...
    // --- Endless Crawler Chapter 1
    Empty,      // 254
    Path,       // 255
}

mod TILE {
    const VOID: u8 = 0;
    const ENTRY: u8 = 1;
    const EXIT: u8 = 2;
    const LOCKED_EXIT: u8 = 3;
    const GEM: u8 = 4;
    const EMPTY: u8 = 254;
    const PATH: u8 = 255;
}

impl TileTypeIntoU8 of Into<TileType, u8> {
    fn into(self: TileType) -> u8 {
        match self {
            TileType::Void => TILE::VOID,
            TileType::Entry => TILE::ENTRY,
            TileType::Exit => TILE::EXIT,
            TileType::LockedExit => TILE::LOCKED_EXIT,
            TileType::Gem => TILE::GEM,
            TileType::Empty => TILE::EMPTY,
            TileType::Path => TILE::PATH,
        }
    }
}
impl TryU8IntoTileType of TryInto<u8, TileType> {
    fn try_into(self: u8) -> Option<TileType> {
        if self == TILE::VOID { Option::Some(TileType::Void) }
        else if self == TILE::ENTRY { Option::Some(TileType::Entry) }
        else if self == TILE::EXIT { Option::Some(TileType::Exit) }
        else if self == TILE::LOCKED_EXIT { Option::Some(TileType::LockedExit) }
        else if self == TILE::GEM { Option::Some(TileType::Gem) }
        else if self == TILE::EMPTY { Option::Some(TileType::Empty) }
        else if self == TILE::PATH { Option::Some(TileType::Path) }
        else { Option::None }
    }
}

impl TileTypeIntoFelt252 of Into<TileType, felt252> {
    fn into(self: TileType) -> felt252 {
        match self {
            TileType::Void => 'Void',
            TileType::Entry => 'Entry',
            TileType::Exit => 'Exit',
            TileType::LockedExit => 'LockedExit',
            TileType::Gem => 'Gem',
            TileType::Empty => 'Empty',
            TileType::Path => 'Path',
        }
    }
}
impl TryFelt252IntoTileType of TryInto<felt252, TileType> {
    fn try_into(self: felt252) -> Option<TileType> {
        if self == 'Void' { Option::Some(TileType::Void) }
        else if self == 'Entry' { Option::Some(TileType::Entry) }
        else if self == 'Exit' { Option::Some(TileType::Exit) }
        else if self == 'LockedExit' { Option::Some(TileType::LockedExit) }
        else if self == 'Gem' { Option::Some(TileType::Gem) }
        else if self == 'Empty' { Option::Some(TileType::Empty) }
        else if self == 'Path' { Option::Some(TileType::Path) }
        else { Option::None }
    }
}

impl PrintTileType of PrintTrait<TileType> {
    fn print(self: TileType) {
        let felt: felt252 = self.into();
        felt.print();
    }
}
