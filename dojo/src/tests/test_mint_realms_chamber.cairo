#[cfg(test)]
mod tests {
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::spawn_test_world;

    use loot_underworld::components::chamber::{chamber, Chamber};
    use loot_underworld::components::chamber::{map, Map};
    use loot_underworld::components::tile::{tile, Tile};
    use loot_underworld::components::tile::{door, Door};
    use loot_underworld::systems::mint_realms_chamber::{mint_realms_chamber};

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

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber() {
        let world = setup_world();

        let token_id: u128 = 1;
        let location: u128 = 123456;

        // Generate one chamber
        world.execute('mint_realms_chamber', array![token_id.into(), location.into()]);

        // check Chamber component
        let query = array![location.into()].span();
        let chamber = world.entity('Chamber', query, 0, dojo::SerdeLen::<Chamber>::len());
        assert(*chamber[0] == token_id.into(), 'bad token_id');
        assert(*chamber[1] == location.into(), 'bad location');
        assert(*chamber[2] != 0, 'bad seed');
        // assert(*chamber[3] == call_data.into(), 'bad minter');

        // check Map component
        let map = world.entity('Map', query, 0, dojo::SerdeLen::<Map>::len());
        assert(*map[1] != 0, 'bad map');
    }

    #[test]
    #[available_gas(1_000_000_000)]
    #[should_panic]
    fn test_mint_realms_chamber_invalid_token_id() {
        let world = setup_world();
        world.execute('mint_realms_chamber', array![0, 999]);
    }

    #[test]
    #[available_gas(1_000_000_000)]
    #[should_panic]
    fn test_mint_realms_chamber_existing() {
        let world = setup_world();
        world.execute('mint_realms_chamber', array![1, 999]);
        world.execute('mint_realms_chamber', array![1, 999]);
    }
}
