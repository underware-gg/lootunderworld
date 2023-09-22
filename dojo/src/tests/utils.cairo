#[cfg(test)]
mod utils {
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

    fn setup_world() -> IWorldDispatcher {
        let mut components = array![chamber::TEST_CLASS_HASH, map::TEST_CLASS_HASH, tile::TEST_CLASS_HASH, door::TEST_CLASS_HASH];
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

    fn mint_get_realms_chamber(world: IWorldDispatcher, token_id: u16, from_location: Location, dir: Dir) -> Chamber {
        let dir_u8: u8 = dir.into();
        world.execute('mint_realms_chamber', array![token_id.into(), from_location.to_id().into(), dir_u8.into()]);
        let to_location: Location = from_location.offset(dir);
        get_world_Chamber(world, to_location.to_id())
    }

    fn get_world_Chamber(world: IWorldDispatcher, location_id: u128) -> Chamber {
        let query = array![location_id.into()].span();
        let component = world.entity('Chamber', query, 0, dojo::SerdeLen::<Chamber>::len());
        Chamber {
            location_id,
            seed: u256 { low:(*component[0]).try_into().unwrap(), high:(*component[1]).try_into().unwrap() },
            minter: (*component[2]).try_into().unwrap(),
            domain_id: (*component[3]).try_into().unwrap(),
            token_id: (*component[4]).try_into().unwrap(),
            yonder: (*component[5]).try_into().unwrap(),
        }
    }

    fn get_world_Map(world: IWorldDispatcher, entity_id: u128) -> Map {
        let query = array![entity_id.into()].span();
        let component = world.entity('Map', query, 0, dojo::SerdeLen::<Map>::len());
        Map {
            entity_id,
            bitmap: u256 { low:(*component[0]).try_into().unwrap(), high:(*component[1]).try_into().unwrap() },
        }
    }

    #[test]
    #[available_gas(10_000)]
    fn test_utils() {
        assert(true != false, 'utils');
    }
}