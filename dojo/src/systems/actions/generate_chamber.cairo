use debug::PrintTrait;
use traits::{Into, TryInto};

use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use loot_underworld::systems::actions::create_door::{create_door};
use loot_underworld::components::chamber::{Chamber, Map};
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::core::carver::{carve};
use loot_underworld::core::collapsor::{collapse};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir};


#[inline(always)]
fn generate_chamber(world: IWorldDispatcher, caller: ContractAddress, from_location: Location, dir: Dir) -> u128 {

    // Shift to location
    let to_location: Location = from_location.offset(dir);
    assert(to_location.validate() == true, 'Invalid to_location');

    // assert chamber is new
    let chamber_id: u128 = to_location.to_id();
    let to_chamber = get!(world, chamber_id, (Chamber));
    assert(to_chamber.token_id == 0, 'Chamber already exists');

    let seed: u256 = make_seed(to_location.token_id.into(), chamber_id);

    // let mut bitmap: u256 = carve(seed, 0x0, 5);
    let mut bitmap: u256 = collapse(seed, false);
    // bitmap = carve(bitmap, 0x0, 4);
    // bitmap = collapse(bitmap, false);

    set!(world,
        (
            Chamber {
                chamber_id,
                seed,
                minter: caller,
                domain_id: to_location.domain_id,
                token_id: to_location.token_id,
            },
            Map {
                entity_id: chamber_id,
                bitmap,
            },
        )
    );

    create_door(world, chamber_id,
        Dir::Over.into(),
        0x88, //136, // (128+8),
    );
    create_door(world, chamber_id,
        Dir::North.into(),
        0x8, //8,
    );
    create_door(world, chamber_id,
        Dir::East.into(),
        0x8f, //143, // (8*16+15),
    );
    create_door(world, chamber_id,
        Dir::West.into(),
        0x80, //128, // (8*16),
    );
    create_door(world, chamber_id,
        Dir::South.into(),
        0xf8, //248, // (15*16+8),
    );


    chamber_id
}
