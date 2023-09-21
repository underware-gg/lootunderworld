use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::systems::actions::create_tile::{create_tile};
use loot_underworld::components::tile::{Door};
use loot_underworld::types::tile_type::{TileType};
use loot_underworld::types::dir::{Dir};

fn create_door(world: IWorldDispatcher, chamber_id: u128, dir: Dir, pos: u8) -> u8 {

    let entity_id: u128 = create_tile(world, chamber_id, pos, TileType::Exit);

    // TODO: Calculate to_location
    let to_location: u128 = chamber_id;

    set!(world, (
        Door { 
            entity_id,
            chamber_id,
            dir: dir.into(),
            to_location,
            open: false,
        }
    ));

    // return door position
    pos
}
