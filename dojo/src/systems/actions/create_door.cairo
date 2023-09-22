use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::core::randomizer::{randomize_door_slot, randomize_door_pos};
use loot_underworld::systems::actions::create_tile::{create_tile};
use loot_underworld::components::chamber::{ChamberDoors};
use loot_underworld::components::tile::{Door};
use loot_underworld::types::tile_type::{TileType};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir};

fn create_door(world: IWorldDispatcher, location: Location, location_id: u128, seed: u256, entry_dir: Dir, dir: Dir) -> u8 {

    // which chamber is this door leading to?
    let to_location: Location = location.offset(dir);
    let to_location_id: u128 = to_location.to_id();
    let to_doors = get!(world, to_location_id, (ChamberDoors));

    let mut tile_type: TileType = TileType::Exit;
    let mut is_open: bool = false;
    let mut pos: u8 = 0;

    let is_entry: bool = (entry_dir == dir);
    if(is_entry) {
        tile_type = TileType::Entry;
    }

    match dir {
        Dir::North => {
            if(to_doors.south > 0) {
                pos = to_doors.south - (15 * 16);
                is_open = true;
            } else {
                pos = randomize_door_slot(seed, dir.into());
            }
        },
        Dir::East => {
            if(to_doors.west > 0) {
                pos = to_doors.west + 15;
                is_open = true;
            } else {
                pos = randomize_door_slot(seed, dir.into()) * 16 + 15;
            }
        },
        Dir::West => {
            if(to_doors.east > 0) {
                pos = to_doors.east - 15;
                is_open = true;
            } else {
                pos = randomize_door_slot(seed, dir.into()) * 16;
            }
        },
        Dir::South => {
            if(to_doors.north > 0) {
                pos = to_doors.north + (15 * 16);
                is_open = true;
            } else {
                pos = randomize_door_slot(seed, dir.into()) + (15 * 16);
            }
        },
        Dir::Over => {
            tile_type = TileType::OverExit;
            if(to_doors.under > 0) {
                pos = to_doors.under;
                is_open = true;
            } else if (is_entry) {
                // TODO: Maybe this should be blocked???
                // can we dig UP ???
                pos = randomize_door_pos(seed, dir.into());
            }
        },
        Dir::Under => {
            tile_type = TileType::UnderExit;
            if(to_doors.over > 0) {
                pos = to_doors.over;
                is_open = true;
            } else if (is_entry) {
                pos = randomize_door_pos(seed, dir.into());
            }
        },
    }

    if(pos == 0) {
        return 0;
    }

    let entity_id: u128 = create_tile(world, location_id, tile_type, pos);

    set!(world, (
        Door { 
            entity_id,
            dir: dir.into(),
            to_location_id,
            is_open: (is_open || is_entry),
        }
    ));

    // TODO: Need to update other chambers????
    // (Map.protected), Door, ChamberDoors

    // return door position
    pos
}
