use debug::PrintTrait;
use traits::{Into, TryInto};

use starknet::{ContractAddress, get_caller_address};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use loot_underworld::systems::actions::generate_doors::{generate_doors};
use loot_underworld::models::chamber::{Chamber, Map, State};
use loot_underworld::core::randomizer::{randomize_door_permissions};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir, DirTrait};
use loot_underworld::types::doors::{Doors};
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::core::generator::{generate};


#[inline(always)]
fn generate_chamber(world: IWorldDispatcher,
    caller: ContractAddress,
    from_location: Location,
    from_dir: Dir,
    mut generator_name: felt252,
    mut generator_value: u32,
) -> u128 {

    let from_location_id: u128 = from_location.to_id();
    let from_chamber: Chamber = get!(world, from_location_id, (Chamber));

    if(from_location.under == 0 && from_location.under == 0) {
        // this is a new Entry from the surface
        assert(from_location.validate_entry() == true, 'Invalid Entry from_location');
        assert(from_chamber.yonder == 0, 'Entry from_chamber exist!?');
        generator_name = 'entry';
        generator_value = 0;
    } else {
        // else, from_chamber must exist
        assert(from_location.validate() == true, 'Invalid from_location');
        assert(from_chamber.yonder > 0, 'from_chamber does not exist');

        // from door should exist
        let from_map: Map = get!(world, from_location_id, (Map));
        let from_door_tile: u8 = from_dir.door_tile_from_map(from_map);
        assert(from_door_tile > 0, 'from_door does not exist');
    }

    // Shift to location
    let chamber_location: Location = from_location.offset(from_dir);
    assert(chamber_location.validate() == true, 'Invalid chamber_location');

    // assert chamber is new
    let location_id: u128 = chamber_location.to_id();
    let chamber: Chamber = get!(world, location_id, (Chamber));
    assert(chamber.yonder == 0, 'Chamber already exists');


    //---------------------
    // Chamber
    //
    // create seed, the initial bitmap state that is used to sculpt it
    let seed: u256 = make_seed(chamber_location.token_id.into(), location_id);
    // clone seed for value randomization
    let mut rnd: u256 = seed;

    // increment yonder
    let yonder: u16 = from_chamber.yonder + 1;


    //---------------------
    // Doors
    //
    let entry_dir: Dir = from_dir.flip();
    let permissions: u8 = randomize_door_permissions(ref rnd, chamber_location, entry_dir, yonder, generator_name);
    let (doors, protected): (Doors, u256) = generate_doors(world, chamber_location, location_id, ref rnd, entry_dir, permissions);


    //---------------------
    // Generate Bitmap
    //
    let bitmap: u256= generate(seed, protected, entry_dir, generator_name, generator_value);
    assert(bitmap != 0, 'Chamber is empty');

    //---------------------
    // Map Component
    //
    set!(world, (
        Chamber {
            location_id,
            seed,
            minter: caller,
            domain_id: chamber_location.domain_id,
            token_id: chamber_location.token_id,
            yonder,
        },
        Map {
            entity_id: location_id,
            bitmap,
            generator_name,
            generator_value,
            north: doors.north,
            east: doors.east,
            west: doors.west,
            south: doors.south,
            over: doors.over,
            under: doors.under,
        },
        State {
            location_id,
            light: 0,
            threat: 0,
            wealth: 0,
        },
    ) );

    location_id
}
