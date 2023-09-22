use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::components::tile::{Tile};
use loot_underworld::types::tile_type::{TileType};

#[inline(always)]
fn create_tile(world: IWorldDispatcher, location_id: u128, pos: u8, tile_type: TileType) -> u128 {
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
