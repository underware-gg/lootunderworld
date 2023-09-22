use debug::PrintTrait;
use traits::{Into, TryInto};

use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use loot_underworld::systems::actions::create_door::{create_door};
use loot_underworld::components::chamber::{Chamber, Map, ChamberDoors};
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::core::carver::{carve};
use loot_underworld::core::collapsor::{collapse};
use loot_underworld::core::protector::{protect};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir, DirTrait};
use loot_underworld::utils::bitwise::{U256Bitwise};


#[inline(always)]
fn generate_chamber(world: IWorldDispatcher, caller: ContractAddress, from_location: Location, from_dir: Dir) -> u128 {

    // Shift to location
    let chamber_location: Location = from_location.offset(from_dir);
    assert(chamber_location.validate() == true, 'Invalid chamber_location');

    // assert chamber is new
    let location_id: u128 = chamber_location.to_id();
    let chamber = get!(world, location_id, (Chamber));
    assert(chamber.yonder == 0, 'Chamber already exists');

    //---------------------
    // Chamber
    //
    let seed: u256 = make_seed(chamber_location.token_id.into(), location_id);

    // increment yonder
    let from_chamber = get!(world, from_location.to_id(), (Chamber));
    let yonder: u16 = from_chamber.yonder + 1;

    set!(world, (
        Chamber {
            location_id,
            seed,
            minter: caller,
            domain_id: chamber_location.domain_id,
            token_id: chamber_location.token_id,
            yonder,
        },
    ));


    //---------------------
    // Doors
    //
    let entry_dir: Dir = from_dir.flip();
    let north: u8 = create_door(world, chamber_location, location_id, seed, entry_dir, Dir::North.into());
    let east: u8 = create_door(world, chamber_location, location_id, seed, entry_dir, Dir::East.into());
    let west: u8 = create_door(world, chamber_location, location_id, seed, entry_dir, Dir::West.into());
    let south: u8 = create_door(world, chamber_location, location_id, seed, entry_dir, Dir::South.into());
    let over: u8 = create_door(world, chamber_location, location_id, seed, entry_dir, Dir::Over.into());
    let under: u8 = create_door(world, chamber_location, location_id, seed, entry_dir, Dir::Under.into());

    // protect doors area
    let mut protected: u256 = 0;
    protected = U256Bitwise::set(protected, north.into());
    protected = U256Bitwise::set(protected, east.into());
    protected = U256Bitwise::set(protected, west.into());
    protected = U256Bitwise::set(protected, south.into());
    if(over > 0) { protected = U256Bitwise::set(protected, over.into()); }
    if(under > 0) { protected = U256Bitwise::set(protected, under.into()); }


    //---------------------
    // Bitmap
    //
    let mut bitmap: u256 = seed;

    bitmap = collapse(bitmap, false);
    // bitmap = carve(bitmap, protected, 5);
    // bitmap = carve(bitmap, protected, 4);
    // bitmap = collapse(bitmap, false);

    // only needed if not using carve()
    bitmap = protect(bitmap, protected);


    set!(world, (
        Map {
            entity_id: location_id,
            bitmap,
            protected,
        },
        ChamberDoors {
            location_id,
            north,
            east,
            west,
            south,
            over,
            under,
        },
    ) );

    location_id
}
