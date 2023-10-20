#[cfg(test)]
mod utils {
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    use loot_underworld::systems::mint_chamber::{mint_chamber, IMintChamberDispatcher, IMintChamberDispatcherTrait};
    use loot_underworld::models::chamber::{Chamber, chamber, Map, map, State, state};
    use loot_underworld::models::tile::{Tile, tile};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir, DirTrait};
    use loot_underworld::types::doors::{Doors};
    use loot_underworld::types::constants::{DOMAINS};

    fn setup_world() -> (IWorldDispatcher, IMintChamberDispatcher) {
        let mut models = array![chamber::TEST_CLASS_HASH, map::TEST_CLASS_HASH, tile::TEST_CLASS_HASH, state::TEST_CLASS_HASH];
        let world: IWorldDispatcher = spawn_test_world(models);
        let contract_address = world.deploy_contract('salt', mint_chamber::TEST_CLASS_HASH.try_into().unwrap());
        let system = IMintChamberDispatcher { contract_address };
        (world, system)
    }

    fn execute_mint_realms_chamber(world: IWorldDispatcher, system: IMintChamberDispatcher, token_id: u16, from_coord: Location, from_dir: Dir, generator_name: felt252, generator_value: u32) {
        system.mint_realms_chamber(token_id.into(), from_coord.to_id(), from_dir.into(), generator_name, generator_value.into());
    }

    fn mint_get_realms_chamber(world: IWorldDispatcher, system: IMintChamberDispatcher, token_id: u16, from_coord: Location, from_dir: Dir, generator_name: felt252, generator_value: u32) -> Chamber {
        execute_mint_realms_chamber(world, system, token_id, from_coord, from_dir, generator_name, generator_value);
        let to_location: Location = from_coord.offset(from_dir);
        get_world_Chamber(world, to_location.to_id())
    }

    fn get_world_Chamber(world: IWorldDispatcher, location_id: u128) -> Chamber {
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

    fn make_from_location(token_id: u16) -> (Location, Dir, u128) {
        let location: Location = Location{ domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let location_id: u128 = location.to_id();
        let dir: Dir = Dir::Under;
        let to_location: Location = location.offset(dir);
        let to_location_id : u128 = to_location.to_id();
        (location, dir, to_location_id)
    }

    #[test]
    #[available_gas(10_000)]
    fn test_utils() {
        assert(true != false, 'utils');
    }
}