#[system]
mod mint_realms_chamber {
    use debug::PrintTrait;
    use traits::{Into, TryInto};
    use core::option::OptionTrait;

    use dojo::world::{Context};

    use loot_underworld::systems::actions::generate_chamber::{generate_chamber};
    use loot_underworld::types::constants::{DOMAINS};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir};

    fn execute(ctx: Context, token_id: u128, from_coord: u128, from_dir: u8) {

        assert(token_id > 0, 'Invalid token id');
        assert(from_dir < 6, 'Invalid direction');

        // TODO: verify ownership
        
        let from_location: Location = LocationTrait::from_coord(DOMAINS::REALMS, token_id.try_into().unwrap(), from_coord);
        let maybe_dir: Option<Dir> = from_dir.try_into();
        
        generate_chamber(ctx.world, ctx.origin, from_location, maybe_dir.unwrap());

        return ();
    }
}
