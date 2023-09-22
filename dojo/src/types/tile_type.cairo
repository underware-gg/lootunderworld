use debug::PrintTrait;

#[derive(Copy, Drop, Serde, PartialEq)]
enum TileType {
    Void,       // 0
    Entry,      // 1
    Exit,       // 2
    LockedExit, // 3
    Gem,        // 4
    //---- NEW
    OverExit,   // 5
    UnderExit,  // 6
    //----
    Empty,      // 254
    Path,       // 255
}

impl TileTypeIntoU8 of Into<TileType, u8> {
    fn into(self: TileType) -> u8 {
        match self {
            TileType::Void => 0,
            TileType::Entry => 1,
            TileType::Exit => 2,
            TileType::LockedExit => 3,
            TileType::Gem => 4,
            TileType::OverExit => 5,
            TileType::UnderExit => 6,
            TileType::Empty => 254,
            TileType::Path => 255,
        }
    }
}
impl TryU8IntoTileType of TryInto<u8, TileType> {
    fn try_into(self: u8) -> Option<TileType> {
        if self == 0 {
            Option::Some(TileType::Void)
        } else if self == 1 {
            Option::Some(TileType::Entry)
        } else if self == 2 {
            Option::Some(TileType::Exit)
        } else if self == 3 {
            Option::Some(TileType::LockedExit)
        } else if self == 4 {
            Option::Some(TileType::Gem)
        } else if self == 5 {
            Option::Some(TileType::OverExit)
        } else if self == 6 {
            Option::Some(TileType::UnderExit)
        } else if self == 254 {
            Option::Some(TileType::Empty)
        } else if self == 255 {
            Option::Some(TileType::Path)
        } else {
            Option::None
        }
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
            TileType::OverExit => 'OverExit',
            TileType::UnderExit => 'UnderExit',
            TileType::Empty => 'Empty',
            TileType::Path => 'Path',
        }
    }
}
impl TryFelt252IntoTileType of TryInto<felt252, TileType> {
    fn try_into(self: felt252) -> Option<TileType> {
        if self == 'Void' {
            Option::Some(TileType::Void)
        } else if self == 'Entry' {
            Option::Some(TileType::Entry)
        } else if self == 'Exit' {
            Option::Some(TileType::Exit)
        } else if self == 'LockedExit' {
            Option::Some(TileType::LockedExit)
        } else if self == 'Gem' {
            Option::Some(TileType::Gem)
        } else if self == 'OverExit' {
            Option::Some(TileType::OverExit)
        } else if self == 'UnderExit' {
            Option::Some(TileType::UnderExit)
        } else if self == 'Empty' {
            Option::Some(TileType::Empty)
        } else if self == 'Path' {
            Option::Some(TileType::Path)
        } else {
            Option::None
        }
    }
}

impl PrintTileType of PrintTrait<TileType> {
    fn print(self: TileType) {
        let felt: felt252 = self.into();
        felt.print();
    }
}
