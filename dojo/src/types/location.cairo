use debug::PrintTrait;
use array::ArrayTrait;

use loot_underworld::utils::bitwise::{U128Bitwise};
use loot_underworld::types::dir::{Dir};

#[derive(Copy, Drop, Serde, PartialEq)]
struct Location {
    domain_id: u16,
    token_id: u16,
    // coord
    over: u16,
    under: u16,
    north: u16,
    east: u16,
    west: u16,
    south: u16,
}

mod CONSTANTS {
    mod OFFSET {
        const DOMAIN_ID: usize  = 112;
        const TOKEN_ID: usize   = 96;
        const OVER: usize       = 80;
        const UNDER: usize      = 64;
        const NORTH: usize      = 48;
        const EAST: usize       = 32;
        const WEST: usize       = 16;
        const SOUTH: usize      = 0;
    }
    mod MASK {
        const DOMAIN_ID: u128   = 0xffff0000000000000000000000000000;
        const TOKEN_ID: u128    = 0xffff000000000000000000000000;
        const OVER: u128        = 0xffff00000000000000000000;
        const UNDER: u128       = 0xffff0000000000000000;
        const NORTH: u128       = 0xffff000000000000;
        const EAST: u128        = 0xffff00000000;
        const WEST: u128        = 0xffff0000;
        const SOUTH: u128       = 0xffff;
    }
}

trait LocationTrait {
    fn validate(self: Location) -> bool;
    fn validate_entry(self: Location) -> bool;
    fn offset(self: Location, dir: Dir) -> Location;
    fn to_id(self: Location) -> u128;
    fn from_id(location_id: u128) -> Location;
    fn from_coord(domain_id: u16, token_id: u16, coord: u128) -> Location;
}

impl LocationTraitImpl of LocationTrait {
    fn validate(self: Location) -> bool {
        (
            self.domain_id > 0
            && self.token_id > 0
            && !((self.over == 0 && self.under == 0) || (self.over > 0 && self.under > 0))
            && !((self.north == 0 && self.south == 0) || (self.north > 0 && self.south > 0))
            && !((self.east == 0 && self.west == 0) || (self.east > 0 && self.west > 0))
        )
    }
    fn validate_entry(self: Location) -> bool {
        (
            self.domain_id > 0
            && self.token_id > 0
            && (self.over == 0 && self.under == 0)
            && !((self.north == 0 && self.south == 0) || (self.north > 0 && self.south > 0))
            && !((self.east == 0 && self.west == 0) || (self.east > 0 && self.west > 0))
        )
    }
    fn offset(self: Location, dir: Dir) -> Location {
        let mut result = self;
        match dir {
            Dir::North => {
                if(self.south > 1) {
                    result.south -= 1;
                } else {
                    result.south = 0;
                    result.north += 1;
                }
            },
            Dir::East => {
                if(self.west > 1) {
                    result.west -= 1;
                } else {
                    result.west = 0;
                    result.east += 1;
                }
            },
            Dir::West => {
                if(self.east > 1) {
                    result.east -= 1;
                } else {
                    result.east = 0;
                    result.west += 1;
                }
            },
            Dir::South => {
                if(self.north > 1) {
                    result.north -= 1;
                } else {
                    result.north = 0;
                    result.south += 1;
                }
            },
            Dir::Over => {
                if(self.under > 1) {
                    result.under -= 1;
                } else {
                    result.under = 0;
                    result.over += 1;
                }
            },
            Dir::Under => {
                if(self.over > 1) {
                    result.over -= 1;
                } else {
                    result.over = 0;
                    result.under += 1;
                }
            },
        }
        result
    }
    fn to_id(self: Location) -> u128 {
        U128Bitwise::shl(self.domain_id.into(), CONSTANTS::OFFSET::DOMAIN_ID) |
        U128Bitwise::shl(self.token_id.into(), CONSTANTS::OFFSET::TOKEN_ID) |
        U128Bitwise::shl(self.over.into(), CONSTANTS::OFFSET::OVER) |
        U128Bitwise::shl(self.under.into(), CONSTANTS::OFFSET::UNDER) |
        U128Bitwise::shl(self.north.into(), CONSTANTS::OFFSET::NORTH) |
        U128Bitwise::shl(self.east.into(), CONSTANTS::OFFSET::EAST) |
        U128Bitwise::shl(self.west.into(), CONSTANTS::OFFSET::WEST) |
        U128Bitwise::shl(self.south.into(), CONSTANTS::OFFSET::SOUTH)
    }
    fn from_id(location_id: u128) -> Location {
        Location {
            domain_id: U128Bitwise::shr(location_id & CONSTANTS::MASK::DOMAIN_ID, CONSTANTS::OFFSET::DOMAIN_ID).try_into().unwrap(),
            token_id: U128Bitwise::shr(location_id & CONSTANTS::MASK::TOKEN_ID, CONSTANTS::OFFSET::TOKEN_ID).try_into().unwrap(),
            over: U128Bitwise::shr(location_id & CONSTANTS::MASK::OVER, CONSTANTS::OFFSET::OVER).try_into().unwrap(),
            under: U128Bitwise::shr(location_id & CONSTANTS::MASK::UNDER, CONSTANTS::OFFSET::UNDER).try_into().unwrap(),
            north: U128Bitwise::shr(location_id & CONSTANTS::MASK::NORTH, CONSTANTS::OFFSET::NORTH).try_into().unwrap(),
            east: U128Bitwise::shr(location_id & CONSTANTS::MASK::EAST, CONSTANTS::OFFSET::EAST).try_into().unwrap(),
            west: U128Bitwise::shr(location_id & CONSTANTS::MASK::WEST, CONSTANTS::OFFSET::WEST).try_into().unwrap(),
            south: U128Bitwise::shr(location_id & CONSTANTS::MASK::SOUTH, CONSTANTS::OFFSET::SOUTH).try_into().unwrap(),
        }
    }
    fn from_coord(domain_id: u16, token_id: u16, coord: u128) -> Location {
        let mut result = LocationTrait::from_id(coord);
        result.domain_id = domain_id;
        result.token_id = token_id;
        result
    }
}

impl LocationPrintImpl of PrintTrait<Location> {
    fn print(self: Location) {
        // let mut oks = ArrayTrait::new();
        self.token_id.print();
        self.over.print();
        self.under.print();
        self.north.print();
        self.east.print();
        self.west.print();
        self.south.print();
    }
}
