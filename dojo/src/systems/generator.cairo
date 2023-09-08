#[system]
mod generate_chamber {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use loot_underworld::components::chamber::Chamber;
    use loot_underworld::utils::seeder::make_seed;
    use loot_underworld::constants::SPAWN_OFFSET;

    // so we don't go negative

    fn execute(ctx: Context, realm_id: u128, coord: u128) {
        // let offset: u32 = SPAWN_OFFSET.try_into().unwrap();

        let block_hask: u128 = 1;
        let seed: u256 = make_seed(realm_id, coord, block_hask);

        set!(ctx.world,
            (
                Chamber {
                    // player: ctx.origin,
                    realm_id,
                    coord,
                    seed,
                    // bitmap: seed,
                },
            )
        );
        return ();
    }
}
