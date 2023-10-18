use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::models::tile::{Tile};
use loot_underworld::types::tile_type::{TileType};

// TODO:  make this internal!
#[inline(always)]
fn create_tile(world: IWorldDispatcher, location_id: u128, pos: u8, tile_type: TileType) {
    set!(world, (
        Tile { 
            key_location_id: location_id,
            key_pos: pos,
            location_id,
            pos,
            tile_type: tile_type.into(),
        }
    ));
}


#[inline(always)]
fn generate_tile(world: IWorldDispatcher, location_id: u128, tile_type: TileType) {

    // TODO: Get Map component (bitmap, protected)

    // TODO: randomize pos
    // TODO: Only over bitmap
    // TODO: Avoid protected
    let pos: u8 = 0;

    // TODO...
    create_tile(world, location_id, pos, tile_type);
    
    // TODO: Update chamber protected bitmap

}
