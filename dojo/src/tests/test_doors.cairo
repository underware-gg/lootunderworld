#[cfg(test)]
mod tests {
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use loot_underworld::models::chamber::{Chamber, Map};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir, DirTrait, DIR};
    use loot_underworld::types::doors::{Doors};
    use loot_underworld::types::tile_type::{TileType, TILE};
    use loot_underworld::types::constants::{DOMAINS};
    use loot_underworld::utils::string::{concat, join};
    use loot_underworld::tests::utils::utils::{
        setup_world,
        mint_get_realms_chamber,
        get_world_Chamber,
        get_world_Map,
        get_world_Doors_as_Tiles,
    };

    fn assert_doors(prefix: felt252, world: IWorldDispatcher, location_id: u128, north: u8, east: u8, west: u8, south: u8, over: u8, under: u8) {
        let tiles: Doors = get_world_Doors_as_Tiles(world, location_id);
        // concat('----', prefix).print();
        // tiles.north.print();
        // tiles.east.print();
        // tiles.west.print();
        // tiles.south.print();
        // tiles.over.print();
        // tiles.under.print();
        assert(tiles.north == north, join(prefix, 'north'));
        assert(tiles.east == east, join(prefix, 'east'));
        assert(tiles.west == west, join(prefix, 'west'));
        assert(tiles.south == south, join(prefix, 'south'));
        assert(tiles.over == over, join(prefix, 'over'));
        assert(tiles.under == under, join(prefix, 'under'));
    }

    #[test]
    #[available_gas(1_000_000_000_000)]
    fn test_doors_connections() {
        let (world, system) = setup_world();
        let token_id: u16 = 5454;

        // 1st chamber: entry from above, all other locked
        let loc1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        assert(loc1.validate_entry() == true, 'entry');
        let chamber1: Chamber = mint_get_realms_chamber(world, system, token_id, loc1, Dir::Under, 'seed', 0);
        assert_doors('entry', world, chamber1.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, 0);

        // move WEST
        let chamber2 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber1.location_id), Dir::West, 'seed', 0);
        assert_doors('move-west-from', world, chamber1.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, 0);
        assert_doors('move-west', world, chamber2.location_id, TILE::LOCKED_EXIT, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, 0, TILE::LOCKED_EXIT);

        // move NORTH
        let chamber3 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber2.location_id), Dir::North, 'seed', 0);
        assert_doors('move-north-from', world, chamber2.location_id, TILE::EXIT, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-north', world, chamber3.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, 0, TILE::LOCKED_EXIT);

        // move EAST
        let chamber4 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber3.location_id), Dir::East, 'seed', 0);
        assert_doors('move-east-from', world, chamber3.location_id, TILE::LOCKED_EXIT, TILE::EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, 0, TILE::LOCKED_EXIT);
        assert_doors('move-east', world, chamber4.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, TILE::EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-east-entry', world, chamber1.location_id, TILE::EXIT, TILE::LOCKED_EXIT, TILE::EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, 0);

        // move EAST+SOUTH
        let chamber5 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber4.location_id), Dir::East, 'seed', 0);
        assert_doors('move-ES_east-from', world, chamber4.location_id, TILE::LOCKED_EXIT, TILE::EXIT, TILE::ENTRY, TILE::EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-ES_east', world, chamber5.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, TILE::LOCKED_EXIT, 0, TILE::LOCKED_EXIT);
        let chamber6 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber5.location_id), Dir::South, 'seed', 0);
        assert_doors('move-ES-from', world, chamber5.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, TILE::EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-ES', world, chamber6.location_id, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::EXIT, TILE::LOCKED_EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-ES-entry', world, chamber1.location_id, TILE::EXIT, TILE::EXIT, TILE::EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, 0);

        // move SOUTH+WEST
        let chamber7 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber6.location_id), Dir::South, 'seed', 0);
        assert_doors('move-SW_south-from', world, chamber6.location_id, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::EXIT, TILE::EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-SW_south', world, chamber7.location_id, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, 0, TILE::LOCKED_EXIT);
        let chamber8 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber7.location_id), Dir::West, 'seed', 0);
        assert_doors('move-SW-from', world, chamber7.location_id, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::EXIT, TILE::LOCKED_EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-SW', world, chamber8.location_id, TILE::EXIT, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, 0, TILE::LOCKED_EXIT);
        assert_doors('move-SW-entry', world, chamber1.location_id, TILE::EXIT, TILE::EXIT, TILE::EXIT, TILE::EXIT, TILE::ENTRY, 0);

        // move UNDER
        let chamber9 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber8.location_id), Dir::Under, 'seed', 0);
        assert_doors('move--under-from', world, chamber8.location_id, TILE::EXIT, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, 0, TILE::EXIT);
        assert_doors('move--under', world, chamber9.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, TILE::LOCKED_EXIT);

        // move NORTH
        let chamber10 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber9.location_id), Dir::North, 'seed', 0);
        assert_doors('move--under_from', world, chamber9.location_id, TILE::EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, TILE::LOCKED_EXIT);
        assert_doors('move--under', world, chamber10.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::ENTRY, 0, TILE::LOCKED_EXIT);
        assert_doors('move--under-entry', world, chamber1.location_id, TILE::EXIT, TILE::EXIT, TILE::EXIT, TILE::EXIT, TILE::ENTRY, 0);

        // move WEST
        let chamber11 = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber10.location_id), Dir::West, 'seed', 0);
        assert_doors('move--west_from', world, chamber10.location_id, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::EXIT, TILE::ENTRY, 0, TILE::LOCKED_EXIT);
        assert_doors('move--west', world, chamber11.location_id, TILE::LOCKED_EXIT, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, TILE::EXIT, TILE::LOCKED_EXIT);
        assert_doors('move--west-2', world, chamber2.location_id, TILE::EXIT, TILE::ENTRY, TILE::LOCKED_EXIT, TILE::LOCKED_EXIT, 0, TILE::EXIT);
    }

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_entry_connect_do_under_sides() {
        let (world, system) = setup_world();
        let token_id: u16 = 255;
        let loc1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let loc2: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:2, east:2, west:0, south:0 };
        let chamber1: Chamber = mint_get_realms_chamber(world, system, token_id, loc1, Dir::Under, 'seed', 0);
        let chamber_N: Chamber = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber1.location_id), Dir::North, 'seed', 0);
        let chamber_E: Chamber = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber1.location_id), Dir::East, 'seed', 0);
        let map_N: Map = get_world_Map(world, chamber_N.location_id);
        let map_E: Map = get_world_Map(world, chamber_E.location_id);
        let chamber2: Chamber = mint_get_realms_chamber(world, system, token_id, loc2, Dir::Under, 'seed', 0);
        let map2: Map = get_world_Map(world, chamber2.location_id);
        assert(Dir::East.flip_door_tile(map_N.east) == map2.west, 'door_N_E');
        assert(Dir::West.flip_door_tile(map2.west) == map_N.east, 'door_N_W');
        assert(Dir::North.flip_door_tile(map_E.north) == map2.south, 'door_E_N');
        assert(Dir::South.flip_door_tile(map2.south) == map_E.north, 'door_E_S');
    }

    #[test]
    #[should_panic(expected:('from_door does not exist','ENTRYPOINT_FAILED'))]
    #[available_gas(1_000_000_000)]
    fn test_from_door_does_not_exist() {
        let (world, system) = setup_world();
        let token_id: u16 = 255;
        let loc1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let chamber1: Chamber = mint_get_realms_chamber(world, system, token_id, loc1, Dir::Under, 'connection', 0);
        let chamber2: Chamber = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber1.location_id), Dir::West, 'connection', 0);
        let map: Map = get_world_Map(world, chamber2.location_id);
        // map.north.print();
        // map.east.print();
        // map.west.print();
        // map.south.print();
        assert(map.west == 0, 'need a closed door to test');
        // now, please panic...
        let chamber3: Chamber = mint_get_realms_chamber(world, system, token_id, LocationTrait::from_id(chamber2.location_id), Dir::West, 'connection', 0);
    }

}
