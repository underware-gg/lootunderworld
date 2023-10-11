use traits::Into;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use loot_underworld::core::randomizer::{randomize_door_slot, randomize_door_pos};
use loot_underworld::systems::actions::create_tile::{create_tile};
use loot_underworld::components::chamber::{Doors};
use loot_underworld::types::tile_type::{TileType};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir, DIR};
use loot_underworld::utils::bitwise::{U8Bitwise};
use loot_underworld::utils::bitmap::{Bitmap};

fn generate_doors(world: IWorldDispatcher,
    location: Location,
    location_id: u128,
    seed: u256,
    entry_dir: Dir,
    permissions: u8,
) -> (Doors, u256) {

    let north: u8 = create_door(world, location, location_id, seed, entry_dir, permissions, Dir::North.into());
    let east: u8  = create_door(world, location, location_id, seed, entry_dir, permissions, Dir::East.into());
    let west: u8  = create_door(world, location, location_id, seed, entry_dir, permissions, Dir::West.into());
    let south: u8 = create_door(world, location, location_id, seed, entry_dir, permissions, Dir::South.into());
    let over: u8  = create_door(world, location, location_id, seed, entry_dir, permissions, Dir::Over.into());
    let under: u8 = create_door(world, location, location_id, seed, entry_dir, permissions, Dir::Under.into());

    // make doors protection bitmap
    let mut protected: u256 = 0;
    if(north > 0) { protected = Bitmap::set_tile(protected, north.into()); }
    if(east > 0)  { protected = Bitmap::set_tile(protected, east.into()); }
    if(west > 0)  { protected = Bitmap::set_tile(protected, west.into()); }
    if(south > 0) { protected = Bitmap::set_tile(protected, south.into()); }
    if(over > 0)  { protected = Bitmap::set_tile(protected, over.into()); }
    if(under > 0) { protected = Bitmap::set_tile(protected, under.into()); }

    (
        Doors { location_id, north, east, west, south, over, under },
        protected,
    )
}

fn create_door(world: IWorldDispatcher,
    location: Location,
    location_id: u128,
    seed: u256,
    entry_dir: Dir,
    permissions: u8,
    dir: Dir,
) -> u8 {

    // which chamber is this door leading to?
    let to_location: Location = location.offset(dir);
    let to_location_id: u128 = to_location.to_id();
    let to_doors = get!(world, to_location_id, (Doors));

    let is_entry: bool = (entry_dir == dir);

    let mut tile_type: TileType = TileType::LockedExit; // default is locked, generated here
    let mut pos: u8 = 0;

    match dir {
        Dir::North => {
            if(to_doors.south > 0) {
                tile_type = TileType::Exit;
                pos = to_doors.south - (15 * 16); // flip pos
                create_tile(world, to_location_id, to_doors.south, TileType::Exit); // open other chamber's door
            } else if(U8Bitwise::is_set(permissions, DIR::NORTH.into())) {
                pos = randomize_door_pos(seed, dir);
            }
        },
        Dir::East => {
            if(to_doors.west > 0) {
                tile_type = TileType::Exit;
                pos = to_doors.west + 15; // flip pos
                create_tile(world, to_location_id, to_doors.west, TileType::Exit); // open other chamber's door
            } else if(U8Bitwise::is_set(permissions, DIR::EAST.into())) {
                pos = randomize_door_pos(seed, dir);
            }
        },
        Dir::West => {
            if(to_doors.east > 0) {
                tile_type = TileType::Exit;
                pos = to_doors.east - 15; // flip pos
                create_tile(world, to_location_id, to_doors.east, TileType::Exit); // open other chamber's door
            } else if(U8Bitwise::is_set(permissions, DIR::WEST.into())) {
                pos = randomize_door_pos(seed, dir);
            }
        },
        Dir::South => {
            if(to_doors.north > 0) {
                tile_type = TileType::Exit;
                pos = to_doors.north + (15 * 16); // flip pos
                create_tile(world, to_location_id, to_doors.north, TileType::Exit); // open other chamber's door
            } else if(U8Bitwise::is_set(permissions, DIR::SOUTH.into())) {
                pos = randomize_door_pos(seed, dir);
            }
        },
        Dir::Over => {
            if(to_doors.under > 0) {
                tile_type = TileType::Exit;
                pos = to_doors.under; // as above, so below
                create_tile(world, to_location_id, to_doors.under, TileType::Exit); // open other chamber's door
            } else if (is_entry) {
                // create the Over door only if it is the entry
                pos = randomize_door_pos(seed, dir);
            }
        },
        Dir::Under => {
            if(to_doors.over > 0) {
                tile_type = TileType::Exit;
                pos = to_doors.over; // as above, so below
                create_tile(world, to_location_id, to_doors.over, TileType::Exit); // open other chamber's door
            } else if(U8Bitwise::is_set(permissions, DIR::UNDER.into())) {
                // create new Under door occasionally
                pos = randomize_door_pos(seed, dir);
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
