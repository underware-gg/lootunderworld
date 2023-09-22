#[cfg(test)]
mod tests {
    use core::traits::Into;
    use array::ArrayTrait;
    use debug::PrintTrait;

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use loot_underworld::systems::mint_realms_chamber::{mint_realms_chamber};
    use loot_underworld::components::chamber::{Chamber};
    use loot_underworld::types::location::{Location, LocationTrait};
    use loot_underworld::types::dir::{Dir};
    use loot_underworld::types::constants::{DOMAINS};
    use loot_underworld::tests::utils::utils::{
        setup_world,
        make_from_location,
        mint_get_realms_chamber,
        get_world_Chamber,
        get_world_Map,
    };

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber() {
        let world = setup_world();
        let token_id: u16 = 255;
        let (location_id, dir, to_location_id) = make_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);

        // check Chamber component
        let chamber = get_world_Chamber(world, to_location_id);
        assert(chamber.seed != 0, 'Chamber: bad seed');
        assert(chamber.seed.low != chamber.seed.high, 'Chamber: seed.low != seed.high');
        // assert(chamber.minter == call_data.into(), 'Chamber: bad minter');
        assert(chamber.domain_id == DOMAINS::REALMS.into(), 'Chamber: bad domain_id');
        assert(chamber.token_id == token_id.into(), 'Chamber: bad token_id');
        assert(chamber.yonder == 1, 'Chamber: bad yonder');

        // check Map component
        let map = get_world_Map(world, to_location_id);
        assert(map.bitmap != 0, 'Map: map != 0');
        assert(map.bitmap.low != map.bitmap.high, 'Map: map.low != map.high');
        assert(map.bitmap != chamber.seed, 'Map: map.high != seed.high');
    }

    #[test]
    #[should_panic]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_invalid_token_id() {
        let world = setup_world();
        let token_id: u16 = 0;
        let (location_id, dir, to_location_id) = make_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);
    }

    #[test]
    #[should_panic]
    #[available_gas(1_000_000_000)]
    fn test_mint_realms_chamber_existing() {
        let world = setup_world();
        let token_id: u16 = 1;
        let (location_id, dir, to_location_id) = make_from_location(token_id);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);
        world.execute('mint_realms_chamber', array![token_id.into(), location_id.into(), dir.into()]);
    }

    #[test]
    #[available_gas(10_000_000_000)]
    fn test_yonder() {
        let world = setup_world();
        let token_id: u16 = 123;
        let loc_y1: Location = Location { domain_id:DOMAINS::REALMS, token_id, over:0, under:0, north:1, east:1, west:0, south:0 };
        let chamber_y1: Chamber = mint_get_realms_chamber(world, token_id, loc_y1, Dir::Under);
        let chamber_y2_1: Chamber = mint_get_realms_chamber(world, token_id, LocationTrait::from_id(chamber_y1.location_id), Dir::North);
        let chamber_y3_1: Chamber = mint_get_realms_chamber(world, token_id, LocationTrait::from_id(chamber_y2_1.location_id), Dir::West);
        let chamber_y4_1: Chamber = mint_get_realms_chamber(world, token_id, LocationTrait::from_id(chamber_y3_1.location_id), Dir::North);
        let chamber_y4_2: Chamber = mint_get_realms_chamber(world, token_id, LocationTrait::from_id(chamber_y3_1.location_id), Dir::West);
        let chamber_y4_3: Chamber = mint_get_realms_chamber(world, token_id, LocationTrait::from_id(chamber_y3_1.location_id), Dir::South);
        let chamber_y2_2: Chamber = mint_get_realms_chamber(world, token_id, LocationTrait::from_id(chamber_y1.location_id), Dir::South);
        let chamber_y3_2: Chamber = mint_get_realms_chamber(world, token_id, LocationTrait::from_id(chamber_y2_2.location_id), Dir::South);
        assert(chamber_y1.yonder == 1, 'chamber_y1');
        assert(chamber_y2_1.yonder == 2, 'chamber_y2_1');
        assert(chamber_y2_2.yonder == 2, 'chamber_y2_2');
        assert(chamber_y3_1.yonder == 3, 'chamber_y3_1');
        assert(chamber_y3_2.yonder == 3, 'chamber_y3_2');
        assert(chamber_y4_1.yonder == 4, 'chamber_y4_1');
        assert(chamber_y4_2.yonder == 4, 'chamber_y4_2');
        assert(chamber_y4_3.yonder == 4, 'chamber_y4_3');
    }
}
