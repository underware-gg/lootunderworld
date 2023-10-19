use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::core::randomizer::{randomize_door_tile};
use loot_underworld::systems::actions::create_tile::{create_tile};
use loot_underworld::models::chamber::{Map};
use loot_underworld::types::tile_type::{TileType};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir, DirTrait, DIR};
use loot_underworld::types::doors::{Doors};
use loot_underworld::utils::bitwise::{U8Bitwise};
use loot_underworld::utils::bitmap::{Bitmap};

fn generate_doors(world: IWorldDispatcher,
    location: Location,
    location_id: u128,
    ref rnd: u256,
    entry_dir: Dir,
    permissions: u8,
) -> (Doors, u256) {

    let doors = Doors {
        north: create_door(world, location, location_id, ref rnd, entry_dir, permissions, Dir::North.into()),
        east:  create_door(world, location, location_id, ref rnd, entry_dir, permissions, Dir::East.into()),
        west:  create_door(world, location, location_id, ref rnd, entry_dir, permissions, Dir::West.into()),
        south: create_door(world, location, location_id, ref rnd, entry_dir, permissions, Dir::South.into()),
        over:  create_door(world, location, location_id, ref rnd, entry_dir, permissions, Dir::Over.into()),
        under: create_door(world, location, location_id, ref rnd, entry_dir, permissions, Dir::Under.into()),
    };

    // make doors protection bitmap
    let mut protected: u256 = 0;
    if(doors.north > 0) { protected = Bitmap::set_tile(protected, doors.north.into()); }
    if(doors.east > 0)  { protected = Bitmap::set_tile(protected, doors.east.into()); }
    if(doors.west > 0)  { protected = Bitmap::set_tile(protected, doors.west.into()); }
    if(doors.south > 0) { protected = Bitmap::set_tile(protected, doors.south.into()); }
    if(doors.over > 0)  { protected = Bitmap::set_tile(protected, doors.over.into()); }
    if(doors.under > 0) { protected = Bitmap::set_tile(protected, doors.under.into()); }

    (doors, protected)
}

fn create_door(world: IWorldDispatcher,
    location: Location,
    location_id: u128,
    ref rnd: u256,
    entry_dir: Dir,
    permissions: u8,
    dir: Dir,
) -> u8 {

    // which chamber is this door leading to?
    let to_location: Location = location.offset(dir);
    let to_location_id: u128 = to_location.to_id();
    let to_map: Map = get!(world, to_location_id, (Map));
    let to_map_exist: bool = (to_map.bitmap != 0);

    let is_entry: bool = (entry_dir == dir);

    let mut tile_type: TileType = TileType::LockedExit; // default is locked, generated here
    let mut pos: u8 = 0;

    match dir {
        Dir::North => {
            if(to_map.south > 0) {
                tile_type = TileType::Exit;
                pos = Dir::South.flip_door_tile(to_map.south);
                create_tile(world, to_location_id, to_map.south, TileType::Exit); // open other chamber's door
            } else if(!to_map_exist && U8Bitwise::is_set(permissions, DIR::NORTH.into())) {
                pos = randomize_door_tile(ref rnd, dir);
            }
        },
        Dir::East => {
            if(to_map.west > 0) {
                tile_type = TileType::Exit;
                pos = Dir::West.flip_door_tile(to_map.west);
                create_tile(world, to_location_id, to_map.west, TileType::Exit); // open other chamber's door
            } else if(!to_map_exist && U8Bitwise::is_set(permissions, DIR::EAST.into())) {
                pos = randomize_door_tile(ref rnd, dir);
            }
        },
        Dir::West => {
            if(to_map.east > 0) {
                tile_type = TileType::Exit;
                pos = Dir::East.flip_door_tile(to_map.east);
                create_tile(world, to_location_id, to_map.east, TileType::Exit); // open other chamber's door
            } else if(!to_map_exist && U8Bitwise::is_set(permissions, DIR::WEST.into())) {
                pos = randomize_door_tile(ref rnd, dir);
            }
        },
        Dir::South => {
            if(to_map.north > 0) {
                tile_type = TileType::Exit;
                pos = Dir::North.flip_door_tile(to_map.north);
                create_tile(world, to_location_id, to_map.north, TileType::Exit); // open other chamber's door
            } else if(!to_map_exist && U8Bitwise::is_set(permissions, DIR::SOUTH.into())) {
                pos = randomize_door_tile(ref rnd, dir);
            }
        },
        Dir::Over => {
            if(to_map.under > 0) {
                tile_type = TileType::Exit;
                pos = Dir::Under.flip_door_tile(to_map.under);
                create_tile(world, to_location_id, to_map.under, TileType::Exit); // open other chamber's door
            } else if (is_entry) {
                // create the Over door only if it is the entry
                pos = randomize_door_tile(ref rnd, dir);
            }
        },
        Dir::Under => {
            if(to_map.over > 0) {
                tile_type = TileType::Exit;
                pos = Dir::Over.flip_door_tile(to_map.over);
                create_tile(world, to_location_id, to_map.over, TileType::Exit); // open other chamber's door
            } else if(!to_map_exist && U8Bitwise::is_set(permissions, DIR::UNDER.into())) {
                // create new Under door occasionally
                pos = randomize_door_tile(ref rnd, dir);
            }
        },
    }

    if(pos == 0) {
        return 0;
    }

    if(is_entry) {
        tile_type = TileType::Entry;
    }

    create_tile(world, location_id, pos, tile_type);

    // return door position
    pos
}
