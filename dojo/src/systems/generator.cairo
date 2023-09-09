#[system]
mod generate_chamber {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use loot_underworld::components::chamber::{Chamber, Map};
    use loot_underworld::utils::seeder::make_seed;
    use loot_underworld::constants::SPAWN_OFFSET;

    fn execute(ctx: Context, realm_id: u128, coord: u128) {
        // let offset: u32 = SPAWN_OFFSET.try_into().unwrap();

        let entity_id = ctx.world.uuid();

        let seed: u256 = make_seed(realm_id, coord);

        set!(ctx.world,
            (
                Chamber {
                    // player: ctx.origin,
                    entity_id: entity_id.into(),
                    realm_id,
                    coord,
                    seed,
                },
                Map {
                    entity_id: entity_id.into(),
                    bitmap: seed,
                },
            )
        );
        return ();
    }
}
