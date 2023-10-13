#[cfg(test)]
mod tests {
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use loot_underworld::systems::mint_realms_chamber::{mint_realms_chamber};
    use loot_underworld::components::chamber::{Chamber};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir, DirTrait, DIR};
    use loot_underworld::types::tile_type::{TileType, TILE};
    use loot_underworld::types::constants::{DOMAINS};
    use loot_underworld::utils::string::{concat, join};
    use loot_underworld::tests::utils::utils::{
        setup_world,
        make_from_location,
        mint_get_realms_get_chamber,
        get_world_Chamber,
        get_world_Map,
    };

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber() {
        let world = setup_world();
        let token_id: u16 = 255;
        let (location_id, dir, to_location_id) = make_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into(), 'whateverrrr', 0]);

        // check Chamber component
        let chamber = get_world_Chamber(world, to_location_id);
        assert(chamber.seed != 0, 'Chamber: bad seed');
        assert(chamber.seed.low != chamber.seed.high, 'Chamber: seed.low != seed.high');
        // assert(chamber.minter == call_data.into(), 'Chamber: bad minter');
        assert(chamber.domain_id == DOMAINS::REALMS.into(), 'Chamber: bad domain_id');
        assert(chamber.token_id == token_id.into(), 'Chamber: bad token_id');
        assert(chamber.yonder == 1, 'Chamber: bad yonder');

        // check Map component
        let map = get_world_Map(world, to_location_id);
        assert(map.bitmap != 0, 'Map: map != 0');
        assert(map.bitmap.low != map.bitmap.high, 'Map: map.low != map.high');
        assert(map.bitmap != chamber.seed, 'Map: map.high != seed.high');
        assert(map.generatorName == 'entry', 'Map: generator name');
        assert(map.generatorValue == 0, 'Map: generator value');
    }

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_generator() {
        let world = setup_world();
        let token_id: u16 = 255;
        let loc1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        // first chamber will always use the 'entry' generator
        let chamber1: Chamber = mint_get_realms_get_chamber(world, token_id, loc1, Dir::Under, 'whateverrrr', 0);
        let map1 = get_world_Map(world, chamber1.location_id);
        assert(map1.generatorName == 'entry', 'map1.name');
        assert(map1.generatorValue == 0, 'map1.value');
        // first chamber will always use the 'entry' generator
        let chamber2 = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber1.location_id), Dir::West, 'collapse', 55);
        let map2 = get_world_Map(world, chamber2.location_id);
        assert(map2.generatorName == 'collapse', 'map2.name');
        assert(map2.generatorValue == 55, 'map2.value');
    }

    #[test]
    #[should_panic(expected:('Invalid generator','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_invalid_generator() {
        let world = setup_world();
        let token_id: u16 = 255;
        let loc1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        // first chamber will always use the 'entry' generator
        let chamber1: Chamber = mint_get_realms_get_chamber(world, token_id, loc1, Dir::Under, 'the_invalid_generator', 0);
        // now a bad generator to panic...
        let chamber2 = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber1.location_id), Dir::West, 'the_invalid_generator', 0);
    }

    #[test]
    #[available_gas(10_000_000_000)]
    fn test_yonder() {
        let world = setup_world();
        let token_id: u16 = 123;
        let loc_y1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let chamber_y1: Chamber = mint_get_realms_get_chamber(world, token_id, loc_y1, Dir::Under, 'entry', 0);
        let chamber_y2_1: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber_y1.location_id), Dir::North, 'seed', 0);
        let chamber_y3_1: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber_y2_1.location_id), Dir::West, 'seed', 0);
        let chamber_y4_1: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber_y3_1.location_id), Dir::North, 'seed', 0);
        let chamber_y4_2: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber_y3_1.location_id), Dir::West, 'seed', 0);
        let chamber_y4_3: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber_y3_1.location_id), Dir::South, 'seed', 0);
        let chamber_y2_2: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber_y1.location_id), Dir::South, 'seed', 0);
        let chamber_y3_2: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber_y2_2.location_id), Dir::South, 'seed', 0);
        assert(chamber_y1.yonder == 1, 'chamber_y1');
        assert(chamber_y2_1.yonder == 2, 'chamber_y2_1');
        assert(chamber_y2_2.yonder == 2, 'chamber_y2_2');
        assert(chamber_y3_1.yonder == 3, 'chamber_y3_1');
        assert(chamber_y3_2.yonder == 3, 'chamber_y3_2');
        assert(chamber_y4_1.yonder == 4, 'chamber_y4_1');
        assert(chamber_y4_2.yonder == 4, 'chamber_y4_2');
        assert(chamber_y4_3.yonder == 4, 'chamber_y4_3');
    }

    #[test]
    #[should_panic(expected:('Chamber already exists','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_already_exists() {
        let world = setup_world();
        let token_id: u16 = 1;
        let (location_id, dir, to_location_id) = make_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into(), 'binary_tree_classic', 0]);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into(), 'binary_tree_classic', 0]);
    }

    #[test]
    #[should_panic(expected:('Invalid token id','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_invalid_token_id() {
        let world = setup_world();
        let token_id: u16 = 0;
        let (location_id, dir, to_location_id) = make_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into(), 'binary_tree_classic', 0]);
    }

    #[test]
    #[should_panic(expected:('Invalid from direction (Over)','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_invalid_from_dir() {
        let world = setup_world();
        let token_id: u16 = 123;
        let (location_id, dir, to_location_id) = make_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), DIR::OVER.into(), 'binary_tree_classic', 0]);
    }

    #[test]
    #[should_panic(expected:('from_door does not exist','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_entry_has_no_under() {
        let world = setup_world();
        let token_id: u16 = 255;
        let loc1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let chamber1: Chamber = mint_get_realms_get_chamber(world, token_id, loc1, Dir::Under, 'connection', 0);
        mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber1.location_id), Dir::Under, 'connection', 0);
    }

    #[test]
    #[should_panic(expected:('Chamber already exists','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_entry_to_existing_chamber() {
        let world = setup_world();
        let token_id: u16 = 255;
        let loc1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let loc2: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:2, east:1, west:0, south:0 };
        let chamber1: Chamber = mint_get_realms_get_chamber(world, token_id, loc1, Dir::Under, 'seed', 0);
        let chamber_N: Chamber = mint_get_realms_get_chamber(world, token_id, LocationTrait::from_id(chamber1.location_id), Dir::North, 'seed', 0);
        // panic here...
        let chamber2: Chamber = mint_get_realms_get_chamber(world, token_id, loc2, Dir::Under, 'seed', 0);
    }

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_baseline_OK() {
        let world = setup_world();
        let token_id: u16 = 212;
        let location: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        world.execute('mint_realms_chamber', array![token_id.into(), location.to_id().into(), DIR::UNDER.into(), 'binary_tree_classic', 0]);
    }

    #[test]
    #[should_panic(expected:('Invalid chamber_location','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_baseline_NOK() {
        let world = setup_world();
        let token_id: u16 = 212;
        let location: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        world.execute('mint_realms_chamber', array![token_id.into(), location.to_id().into(), DIR::WEST.into(), 'binary_tree_classic', 0]);
    }

    #[test]
    #[should_panic(expected:('Invalid Entry from_location','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_invalid_entry_location() {
        let world = setup_world();
        let token_id: u16 = 232;
        let location: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:0, west:0, south:1 };
        world.execute('mint_realms_chamber', array![token_id.into(), location.to_id().into(), DIR::UNDER.into(), 'binary_tree_classic', 0]);
    }

    #[test]
    #[should_panic(expected:('from_chamber does not exist','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_from_chamber_does_not_exist() {
        let world = setup_world();
        let token_id: u16 = 232;
        let location: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:1, north:11, east:11, west:0, south:0 };
        world.execute('mint_realms_chamber', array![token_id.into(), location.to_id().into(), DIR::UNDER.into(), 'binary_tree_classic', 0]);
    }

    #[test]
    #[should_panic(expected:('Invalid chamber_location','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_invalid_entry_direction() {
        let world = setup_world();
        let token_id: u16 = 434;
        let location: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        world.execute('mint_realms_chamber', array![token_id.into(), location.to_id().into(), DIR::EAST.into(), 'binary_tree_classic', 0]);
    }

}
