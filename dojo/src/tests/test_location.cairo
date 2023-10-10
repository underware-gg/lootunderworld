#[cfg(test)]
mod tests {
    use loot_underworld::types::location::{Location, LocationTrait, CONSTANTS};
    use loot_underworld::utils::bitwise::{U128Bitwise};
    use loot_underworld::types::dir::{Dir};
    use debug::PrintTrait;

    #[test]
    #[available_gas(10_000_000)]
    fn test_location_equality() {
        let ok1 = Location{ domain_id:1, token_id:1, over:3, under:0, north:3, east:3, west:0, south:0 };
        let ok2 = Location{ domain_id:1, token_id:1, over:0, under:3, north:0, east:0, west:3, south:3 };
        assert(ok1 == ok1, 'ok1 == ok1');
        assert(ok2 == ok2, 'ok2 == ok2');
        assert(ok1 != ok2, 'ok1 != ok2');
    }

    #[test]
    #[available_gas(1_000_000)]
    fn test_location_constants() {
        assert(CONSTANTS::OFFSET::DOMAIN_ID == (16 * 7), 'CONSTANTS::OFFSET::DOMAIN_ID');
        assert(CONSTANTS::OFFSET::TOKEN_ID == (16 * 6), 'CONSTANTS::OFFSET::TOKEN_ID');
        assert(CONSTANTS::OFFSET::OVER == (16 * 5), 'CONSTANTS::OFFSET::OVER');
        assert(CONSTANTS::OFFSET::UNDER == (16 * 4), 'CONSTANTS::OFFSET::UNDER');
        assert(CONSTANTS::OFFSET::NORTH == (16 * 3), 'CONSTANTS::OFFSET::NORTH');
        assert(CONSTANTS::OFFSET::EAST == (16 * 2), 'CONSTANTS::OFFSET::EAST');
        assert(CONSTANTS::OFFSET::WEST == (16 * 1), 'CONSTANTS::OFFSET::WEST');
        assert(CONSTANTS::OFFSET::SOUTH == (16 * 0), 'CONSTANTS::OFFSET::SOUTH');
        assert(CONSTANTS::MASK::DOMAIN_ID == U128Bitwise::shl(0xffff, 16 * 7), 'CONSTANTS::MASK::DOMAIN_ID');
        assert(CONSTANTS::MASK::TOKEN_ID == U128Bitwise::shl(0xffff, 16 * 6), 'CONSTANTS::MASK::TOKEN_ID');
        assert(CONSTANTS::MASK::OVER == U128Bitwise::shl(0xffff, 16 * 5), 'CONSTANTS::MASK::OVER');
        assert(CONSTANTS::MASK::UNDER == U128Bitwise::shl(0xffff, 16 * 4), 'CONSTANTS::MASK::UNDER');
        assert(CONSTANTS::MASK::NORTH == U128Bitwise::shl(0xffff, 16 * 3), 'CONSTANTS::MASK::NORTH');
        assert(CONSTANTS::MASK::EAST == U128Bitwise::shl(0xffff, 16 * 2), 'CONSTANTS::MASK::EAST');
        assert(CONSTANTS::MASK::WEST == U128Bitwise::shl(0xffff, 16 * 1), 'CONSTANTS::MASK::WEST');
        assert(CONSTANTS::MASK::SOUTH == U128Bitwise::shl(0xffff, 16 * 0), 'CONSTANTS::MASK::SOUTH');
    }

    #[test]
    #[available_gas(10_000_000)]
    fn test_location_validate() {
        // fails
        assert(Location{ domain_id:0, token_id:0, over:0, under:0, north:0, east:0, west:0, south:0 }.validate() == false, 'zeros');
        // oks
        let mut oks = ArrayTrait::new();
        oks.append(Location{ domain_id:1, token_id:1, over:0, under:1, north:1, east:1, west:0, south:0 });
        oks.append(Location{ domain_id:1, token_id:1, over:0, under:1, north:1, east:0, west:1, south:0 });
        oks.append(Location{ domain_id:1, token_id:1, over:0, under:1, north:0, east:1, west:0, south:1 });
        oks.append(Location{ domain_id:1, token_id:1, over:0, under:1, north:0, east:0, west:1, south:1 });
        oks.append(Location{ domain_id:1, token_id:1, over:1, under:0, north:1, east:1, west:0, south:0 });
        oks.append(Location{ domain_id:1, token_id:1, over:1, under:0, north:1, east:0, west:1, south:0 });
        oks.append(Location{ domain_id:1, token_id:1, over:1, under:0, north:0, east:1, west:0, south:1 });
        oks.append(Location{ domain_id:1, token_id:1, over:1, under:0, north:0, east:0, west:1, south:1 });        
        let mut i: usize = 0;
        loop {
            if(i == oks.len()) { break; }
            let ok = *oks[i];
            let mut loc = ok;
            assert(loc.validate() == true, 'ok');
            assert(loc.validate_entry() == false, '!entry');
            loc = ok; loc.domain_id = 0;
            assert(loc.validate() == false, '!domain_id');
            loc = ok; loc.token_id = 0;
            assert(loc.validate() == false, '!token_id');
            if(ok.over > 0) {
                loc = ok; loc.over = 0;
                assert(loc.validate() == false, '!over');
                assert(loc.validate_entry() == true, '!entry_over');
            }
            if(ok.under > 0) {
                loc = ok; loc.under = 0;
                assert(loc.validate() == false, '!under');
                assert(loc.validate_entry() == true, '!entry_under');
            }
            if(ok.north > 0) {
                loc = ok; loc.north = 0;
                assert(loc.validate() == false, '!north');
                assert(loc.validate_entry() == false, '!entry_north');
            }
            if(ok.east > 0) {
                loc = ok; loc.east = 0;
                assert(loc.validate() == false, '!east');
                assert(loc.validate_entry() == false, '!entry_east');
            }
            if(ok.west > 0) {
                loc = ok; loc.west = 0;
                assert(loc.validate() == false, '!west');
                assert(loc.validate_entry() == false, '!entry_west');
            }
            if(ok.south > 0) {
                loc = ok; loc.south = 0;
                assert(loc.validate() == false, '!south');
                assert(loc.validate_entry() == false, '!entry_south');
            }
            i += 1;
        };
    }

    #[test]
    #[available_gas(10_000_000)]
    fn test_location_id() {
        let base = Location {
            domain_id: 0x8111,
            token_id: 0x8222,
            over: 0x8333,
            under: 0x8444,
            north: 0x8555,
            east: 0x8666,
            west: 0x8777,
            south: 0x8fff,
        };
        assert(base.validate() == false, 'validate');
        let id: u128 = base.to_id();
        assert(id & CONSTANTS::MASK::DOMAIN_ID == U128Bitwise::shl(base.domain_id.into(), CONSTANTS::OFFSET::DOMAIN_ID), 'id.domain_id');
        assert(id & CONSTANTS::MASK::TOKEN_ID == U128Bitwise::shl(base.token_id.into(), CONSTANTS::OFFSET::TOKEN_ID), 'id.token_id');
        assert(id & CONSTANTS::MASK::OVER == U128Bitwise::shl(base.over.into(), CONSTANTS::OFFSET::OVER), 'id.over');
        assert(id & CONSTANTS::MASK::UNDER == U128Bitwise::shl(base.under.into(), CONSTANTS::OFFSET::UNDER), 'id.under');
        assert(id & CONSTANTS::MASK::NORTH == U128Bitwise::shl(base.north.into(), CONSTANTS::OFFSET::NORTH), 'id.north');
        assert(id & CONSTANTS::MASK::EAST == U128Bitwise::shl(base.east.into(), CONSTANTS::OFFSET::EAST), 'id.east');
        assert(id & CONSTANTS::MASK::WEST == U128Bitwise::shl(base.west.into(), CONSTANTS::OFFSET::WEST), 'id.west');
        assert(id & CONSTANTS::MASK::SOUTH == U128Bitwise::shl(base.south.into(), CONSTANTS::OFFSET::SOUTH), 'id.south');
        let loc: Location = LocationTrait::from_id(id);
        assert(loc.domain_id == base.domain_id, 'loc.domain_id');
        assert(loc.token_id == base.token_id, 'loc.token_id');
        assert(loc.over == base.over, 'loc.over');
        assert(loc.under == base.under, 'loc.under');
        assert(loc.north == base.north, 'loc.north');
        assert(loc.east == base.east, 'loc.east');
        assert(loc.west == base.west, 'loc.west');
        assert(loc.south == base.south, 'loc.south');
    }

    #[test]
    #[available_gas(10_000_000)]
    fn test_location_coord() {
        let base = Location {
            domain_id: 0x8111, // whatever, will be erased
            token_id: 0x8222,  // whatever, will be erased
            over: 0x8333,
            under: 0x8444,
            north: 0x8555,
            east: 0x8666,
            west: 0x8777,
            south: 0x8fff,
        };
        let coord: u128 = base.to_id();
        let loc: Location = LocationTrait::from_coord(0x8080, 0x8888, coord);
        assert(loc.domain_id == 0x8080, 'loc.domain_id');
        assert(loc.token_id == 0x8888, 'loc.token_id');
        assert(loc.over == base.over, 'loc.over');
        assert(loc.under == base.under, 'loc.under');
        assert(loc.north == base.north, 'loc.north');
        assert(loc.east == base.east, 'loc.east');
        assert(loc.west == base.west, 'loc.west');
        assert(loc.south == base.south, 'loc.south');
        assert(loc != base, 'loc != base');
    }

    #[test]
    #[available_gas(10_000_000)]
    fn test_location_offset() {
        let ok1 = Location{ domain_id:1, token_id:1, over:3, under:0, north:3, east:3, west:0, south:0 };
        let ok2 = Location{ domain_id:1, token_id:1, over:0, under:3, north:0, east:0, west:3, south:3 };
        assert(ok1.validate() == true, 'ok1 is ok');
        assert(ok2.validate() == true, 'ok2 is ok');
        // up to ok2
        let mut loc = ok1;
        let mut i: u16 = 0;
        loop {
            if (i == 5) { break; }
            loc = loc.offset(Dir::Under);
            assert(loc.validate() == true, 'Dir::Under');
            loc = loc.offset(Dir::South);
            assert(loc.validate() == true, 'Dir::South');
            loc = loc.offset(Dir::West);
            assert(loc.validate() == true, 'Dir::Under');
            if (i < 2) {
                // 0 > 2
                // 1 > 1
                let value: u16 = 2 - i;
                assert(loc.over == value, 'loc.over+');
                assert(loc.north == value, 'loc.north+');
                assert(loc.east == value, 'loc.east+');
                assert(loc.under == 0, 'loc.under-');
                assert(loc.south == 0, 'loc.south-');
                assert(loc.west == 0, 'loc.west-');
            } else {
                // 2 > 1
                // 3 > 2
                // 4 > 3
                let value: u16 = i - 1;
                assert(loc.over == 0, 'loc.over-');
                assert(loc.north == 0, 'loc.north-');
                assert(loc.east == 0, 'loc.east-');
                assert(loc.under == value, 'loc.under+');
                assert(loc.south == value, 'loc.south+');
                assert(loc.west == value, 'loc.west+');
            }
            i += 1;
        };
        assert(loc == ok2, 'loc == ok2');
        // back to ok1
        i = 0;
        loop {
            if (i == 5) { break; }
            loc = loc.offset(Dir::Over);
            assert(loc.validate() == true, 'Dir::Over');
            loc = loc.offset(Dir::North);
            assert(loc.validate() == true, 'Dir::North');
            loc = loc.offset(Dir::East);
            assert(loc.validate() == true, 'Dir::East');
            if (i < 2) {
                // 0 > 2
                // 1 > 1
                let value: u16 = 2 - i;
                assert(loc.over == 0, '_loc.over-');
                assert(loc.north == 0, '_loc.north-');
                assert(loc.east == 0, '_loc.east-');
                assert(loc.under == value, '_loc.under+');
                assert(loc.south == value, '_loc.south+');
                assert(loc.west == value, '_loc.west+');
            } else {
                // 2 > 1
                // 3 > 2
                // 4 > 3
                let value: u16 = i - 1;
                assert(loc.over == value, '_loc.over+');
                assert(loc.north == value, '_loc.north+');
                assert(loc.east == value, '_loc.east+');
                assert(loc.under == 0, '_loc.under-');
                assert(loc.south == 0, '_loc.south-');
                assert(loc.west == 0, '_loc.west-');
            }
            i += 1;
        };
        assert(loc == ok1, 'loc == ok1');
    }
}
