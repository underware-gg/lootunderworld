#[cfg(test)]
mod utils {
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::spawn_test_world;

    use loot_underworld::systems::mint_realms_chamber::{mint_realms_chamber};
    use loot_underworld::components::chamber::{Chamber, chamber, Map, map, State, state};
    use loot_underworld::components::tile::{Tile, tile};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir};
    use loot_underworld::types::doors::{Doors};
    use loot_underworld::types::constants::{DOMAINS};

    fn setup_world() -> IWorldDispatcher {
        let mut components = array![chamber::TEST_CLASS_HASH, map::TEST_CLASS_HASH, tile::TEST_CLASS_HASH, state::TEST_CLASS_HASH];
        let mut systems = array![mint_realms_chamber::TEST_CLASS_HASH];
        spawn_test_world(components, systems)
    }

    fn make_from_location(token_id: u16) -> (u128, u8, u128) {
        let location: Location = Location{ domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let location_id: u128 = location.to_id();
        let dir: u8 = Dir::Under.into();
        let to_location: Location = location.offset(Dir::Under);
        let to_location_id : u128 = to_location.to_id();
        (location_id, dir, to_location_id)
    }

    fn mint_get_realms_get_chamber(world: IWorldDispatcher, token_id: u16, from_coord: Location, from_dir: Dir, generatorName: felt252, generatorValue: u32) -> Chamber {
        let dir_u8: u8 = from_dir.into();
        world.execute('mint_realms_chamber', array![token_id.into(), from_coord.to_id().into(), dir_u8.into(), generatorName.into(), generatorValue.into()]);
        let to_location: Location = from_coord.offset(from_dir);
        get_world_Chamber(world, to_location.to_id())
    }

    fn get_world_Chamber(world: IWorldDispatcher, location_id: u128) -> Chamber {
        // let query = array![location_id.into()].span();
        // let component = world.entity('Chamber', query, 0, dojo::SerdeLen::<Chamber>::len());
        // Chamber {
        //     location_id,
        //     seed: u256 { low:(*component[0]).try_into().unwrap(), high:(*component[1]).try_into().unwrap() },
        //     minter: (*component[2]).try_into().unwrap(),
        //     domain_id: (*component[3]).try_into().unwrap(),
        //     token_id: (*component[4]).try_into().unwrap(),
        //     yonder: (*component[5]).try_into().unwrap(),
        // }
        let result: Chamber = get!(world, location_id, Chamber);
        (result)
    }

    fn get_world_Map(world: IWorldDispatcher, entity_id: u128) -> Map {
        let result: Map = get!(world, entity_id, Map);
        (result)
    }

    fn get_world_State(world: IWorldDispatcher, location_id: u128) -> State {
        let result: State = get!(world, location_id, State);
        (result)
    }

    fn get_world_Tile_type(world: IWorldDispatcher, location_id: u128, pos: u8) -> u8 {
        // let query = array![location_id.into(), pos.into()].span();
        // let component = world.entity('Tile', query, 0, dojo::SerdeLen::<Tile>::len());
        let tile: Tile = get!(world, (location_id, pos), Tile);
        (tile.tile_type)
    }

    fn get_world_Doors_as_Tiles(world: IWorldDispatcher, location_id: u128) -> Doors {
        let map: Map = get_world_Map(world, location_id);
        Doors {
            north: get_world_Tile_type(world, location_id, map.north),
            east: get_world_Tile_type(world, location_id, map.east),
            west: get_world_Tile_type(world, location_id, map.west),
            south: get_world_Tile_type(world, location_id, map.south),
            over: get_world_Tile_type(world, location_id, map.over),
            under: get_world_Tile_type(world, location_id, map.under),
        }
    }

    #[test]
    #[available_gas(10_000)]
    fn test_utils() {
        assert(true != false, 'utils');
    }
}