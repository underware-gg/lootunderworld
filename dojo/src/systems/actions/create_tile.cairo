use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::components::tile::{Tile};
use loot_underworld::types::tile_type::{TileType};

// TODO:  make this internal!
#[inline(always)]
fn create_tile(world: IWorldDispatcher, location_id: u128, tile_type: TileType, pos: u8) -> u128 {

    let entity_id: u128 = world.uuid().into();

    set!(world, (
        Tile { 
            entity_id,
            location_id,
            pos,
            tile_type: tile_type.into(),
        }
    ));

    entity_id
}


#[inline(always)]
fn generate_tile(world: IWorldDispatcher, location_id: u128, tile_type: TileType) -> u128 {

    // TODO: Get Map component (bitmap, protected)

    // TODO: randomize pos
    // TODO: Only over bitmap
    // TODO: Avoid protected
    let pos: u8 = 0;

    // TODO...
    let entity_id: u128 = create_tile(world, location_id, tile_type, pos);
    
    // TODO: Update chamber protected bitmap

    entity_id
}
