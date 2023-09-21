#[cfg(test)]
mod tests {
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::spawn_test_world;

    use loot_underworld::systems::mint_realms_chamber::{mint_realms_chamber};
    use loot_underworld::components::chamber::{chamber, Chamber};
    use loot_underworld::components::chamber::{map, Map};
    use loot_underworld::components::tile::{tile, Tile};
    use loot_underworld::components::tile::{door, Door};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir};
    use loot_underworld::types::constants::{DOMAINS};

    // helper setup function
    // reuse this function for all tests
    fn setup_world() -> IWorldDispatcher {
        // components
        let mut components = array![chamber::TEST_CLASS_HASH, map::TEST_CLASS_HASH, tile::TEST_CLASS_HASH, door::TEST_CLASS_HASH];

        // systems
        let mut systems = array![mint_realms_chamber::TEST_CLASS_HASH];

        // deploy executor, world and register components/systems
        spawn_test_world(components, systems)
    }

    fn get_from_location(token_id: u16) -> (u128, u8, u128) {
        let location: Location = Location{ domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let location_id: u128 = location.to_id();
        let dir: u8 = Dir::Under.into();
        let to_location: Location = location.offset(Dir::Under);
        let to_location_id : u128 = to_location.to_id();
        (location_id, dir, to_location_id)
    }

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber() {
        let world = setup_world();
        let token_id: u16 = 255;
        let (location_id, dir, to_location_id) = get_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);

        // check Chamber component
        let query = array![to_location_id.into()].span();
        let chamber = world.entity('Chamber', query, 0, dojo::SerdeLen::<Chamber>::len());
        assert(*chamber[0] != 0, 'Chamber: bad seed.low');
        assert(*chamber[1] != 0, 'Chamber: bad seed.high');
        assert(*chamber[0] != *chamber[1], 'Chamber: seed.low != seed.high');
        // assert(*chamber[2] == call_data.into(), 'Chamber: bad minter');
        assert(*chamber[3] == DOMAINS::REALMS.into(), 'Chamber: bad domain_id');
        assert(*chamber[4] == token_id.into(), 'Chamber: bad token_id');

        // check Map component
        let map = world.entity('Map', query, 0, dojo::SerdeLen::<Map>::len());
        assert(*map[0] != 0, 'Map: map.low != 0');
        assert(*map[1] != 0, 'Map: map.low != 0');
        assert(*map[0] != *map[1], 'Map: map.low != map.high');
        assert(*map[0] != *chamber[0], 'Map: map.low != seed.low');
        assert(*map[1] != *chamber[1], 'Map: map.high != seed.high');
    }

    #[test]
    #[should_panic]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_invalid_token_id() {
        let world = setup_world();
        let token_id: u16 = 0;
        let (location_id, dir, to_location_id) = get_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);
    }

    #[test]
    #[should_panic]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_existing() {
        let world = setup_world();
        let token_id: u16 = 1;
        let (location_id, dir, to_location_id) = get_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);
    }
}
