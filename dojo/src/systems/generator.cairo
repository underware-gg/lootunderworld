
#[system]
mod generate_chamber {
    // use debug::PrintTrait;
    use traits::{Into, TryInto};
    use dojo::world::{Context}; //{Context, IWorldDispatcher, IWorldDispatcherTrait};

    use loot_underworld::components::chamber::{Chamber, Map};
    use loot_underworld::core::seeder::{make_seed};
    use loot_underworld::core::carver::{carve};
    use loot_underworld::core::collapsor::{collapse};
    use loot_underworld::core::tiler::{create_door};
    use loot_underworld::types::dir::{Dir};

    fn execute(ctx: Context, token_id: u128, location: u128) {
        
        let chamber_id: u128 = ctx.world.uuid().into();

        let seed: u256 = make_seed(token_id, location);
        // let seed: u256 = 0xffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa9999999988888888;
        // seed.low.print();
        // seed.high.print();

        let mut bitmap: u256 = carve(seed, 0x0, 5);
        bitmap = carve(bitmap, 0x0, 5);
        // let bitmap: u256 = collapse(seed, false);
        // bitmap.low.print();
        // bitmap.high.print();

        set!(ctx.world,
            (
                Chamber {
                    chamber_id,
                    token_id,
                    location,
                    seed,
                    minter: ctx.origin,
                },
                Map {
                    entity_id: chamber_id,
                    bitmap,
                },
            )
        );

        create_door(ctx.world, chamber_id, location,
            Dir::Over.into(),
            0x88, //136, // (128+8),
        );
        create_door(ctx.world, chamber_id, location,
            Dir::North.into(),
            0x8, //8,
        );
        create_door(ctx.world, chamber_id, location,
            Dir::East.into(),
            0x8f, //143, // (8*16+15),
        );
        create_door(ctx.world, chamber_id, location,
            Dir::West.into(),
            0x80, //128, // (8*16),
        );
        create_door(ctx.world, chamber_id, location,
            Dir::South.into(),
            0xf8, //248, // (15*16+8),
        );

        return ();
    }
}
