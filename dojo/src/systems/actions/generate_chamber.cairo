use debug::PrintTrait;
use traits::{Into, TryInto};

use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use loot_underworld::systems::actions::create_door::{create_door};
use loot_underworld::components::chamber::{Chamber, Map};
use loot_underworld::core::seeder::{make_seed};
use loot_underworld::core::carver::{carve};
use loot_underworld::core::collapsor::{collapse};
use loot_underworld::core::protector::{protect};
use loot_underworld::types::location::{Location, LocationTrait};
use loot_underworld::types::dir::{Dir};
use loot_underworld::utils::bitwise::{U256Bitwise};


#[inline(always)]
fn generate_chamber(world: IWorldDispatcher, caller: ContractAddress, from_location: Location, dir: Dir) -> u128 {

    // Shift to location
    let to_location: Location = from_location.offset(dir);
    assert(to_location.validate() == true, 'Invalid to_location');

    // assert chamber is new
    let chamber_id: u128 = to_location.to_id();
    let to_chamber = get!(world, chamber_id, (Chamber));
    assert(to_chamber.token_id == 0, 'Chamber already exists');

    //---------------------
    // Chamber
    //
    let seed: u256 = make_seed(to_location.token_id.into(), chamber_id);

    // increment yonder
    let from_chamber = get!(world, from_location.to_id(), (Chamber));
    let yonder: u16 = from_chamber.yonder + 1;

    set!(world, (
        Chamber {
            chamber_id,
            seed,
            minter: caller,
            domain_id: to_location.domain_id,
            token_id: to_location.token_id,
            yonder,
        },
    ));

    //---------------------
    // Doors
    //
    let mut protected: u256 = 0;
    let mut pos: u8 = 0;

    pos = create_door(world, chamber_id,
        Dir::Over.into(),
        0x88, //136, // (128+8),
    );
    protected = U256Bitwise::set(protected, pos.into());

    pos = create_door(world, chamber_id,
        Dir::North.into(),
        0x8, //8,
    );
    protected = U256Bitwise::set(protected, pos.into());

    pos = create_door(world, chamber_id,
        Dir::East.into(),
        0x8f, //143, // (8*16+15),
    );
    protected = U256Bitwise::set(protected, pos.into());

    pos = create_door(world, chamber_id,
        Dir::West.into(),
        0x80, //128, // (8*16),
    );
    protected = U256Bitwise::set(protected, pos.into());

    pos = create_door(world, chamber_id,
        Dir::South.into(),
        0xf8, //248, // (15*16+8),
    );
    protected = U256Bitwise::set(protected, pos.into());

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
            entity_id: chamber_id,
            bitmap,
        },
    ) );

    chamber_id
}
