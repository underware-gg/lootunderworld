#[system]
mod mint_realms_chamber {
    use debug::PrintTrait;
    use traits::{Into, TryInto};
    use core::option::OptionTrait;

    use dojo::world::{Context};

    use loot_underworld::systems::actions::generate_chamber::{generate_chamber};
    use loot_underworld::types::constants::{DOMAINS};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir, DIR, DirTrait};

    fn execute(ctx: Context,
        token_id: u128,
        from_coord: u128,
        from_dir: u8, 
        generatorName: felt252,
        generatorValue: u32,
    ) {

        assert(token_id > 0, 'Invalid token id');

        // TODO: verify token ownership
        
        // verify its a valid direction
        assert(from_dir < DIR::COUNT, 'Invalid from direction');
        assert(from_dir != DIR::OVER, 'Invalid from direction (Over)');
        
        let from_location: Location = LocationTrait::from_coord(DOMAINS::REALMS, token_id.try_into().unwrap(), from_coord);
        let maybe_dir: Option<Dir> = from_dir.try_into();

        generate_chamber(ctx.world, ctx.origin, from_location, maybe_dir.unwrap(), generatorName, generatorValue);

        return ();
    }
}
