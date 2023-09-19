use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::components::tile::{Tile, Door};
use loot_underworld::types::tile_type::{TileType};
use loot_underworld::types::dir::{Dir};

#[inline(always)]
fn create_tile(world: IWorldDispatcher, chamber_id: u128, pos: u8, tile_type: TileType) -> u128 {
    let entity_id: u128 = world.uuid().into();

    set!(world, (
        Tile { 
            entity_id,
            chamber_id,
            pos,
            tile_type: tile_type.into(),
        }
    ));

    entity_id
}

fn create_door(world: IWorldDispatcher, chamber_id: u128, location: u128, dir: Dir, pos: u8) -> u128 {

    let entity_id: u128 = create_tile(world, chamber_id, pos, TileType::Exit);

    set!(world, (
        Door { 
            entity_id,
            chamber_id,
            dir: dir.into(),
            to_location: location,
            open: false,
        }
    ));

    entity_id
}

