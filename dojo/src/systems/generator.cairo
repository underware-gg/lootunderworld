
#[system]
mod generate_chamber {
    use debug::PrintTrait;
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use loot_underworld::components::chamber::{Chamber, Map, Door};
    use loot_underworld::core::dir::{Dir};
    use loot_underworld::utils::seeder::{make_seed};

    fn execute(ctx: Context, realm_id: u128, location: u128) {

        let entity_id = ctx.world.uuid();

        let seed: u256 = make_seed(realm_id, location);
        // let seed: u256 = 0xffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa9999999988888888;
        seed.low.print();
        seed.high.print();

        set!(ctx.world,
            (
                Chamber {
                    minter: ctx.origin,
                    entity_id: entity_id.into(),
                    realm_id,
                    location,
                    seed,
                },
                Map {
                    entity_id: entity_id.into(),
                    bitmap: seed,
                },
                Door {
                    entity_id: entity_id.into(),
                    dir: Dir::Over.into(),
                    pos: 0,
                    toLocation: location,
                },
                Door {
                    entity_id: entity_id.into(),
                    dir: Dir::North.into(),
                    pos: 0,
                    toLocation: location,
                },
                Door {
                    entity_id: entity_id.into(),
                    dir: Dir::East.into(),
                    pos: 0,
                    toLocation: location,
                },
                Door {
                    entity_id: entity_id.into(),
                    dir: Dir::West.into(),
                    pos: 0,
                    toLocation: location,
                },
                Door {
                    entity_id: entity_id.into(),
                    dir: Dir::South.into(),
                    pos: 0,
                    toLocation: location,
                },
            )
        );
        return ();
    }
}
