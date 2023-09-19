use array::ArrayTrait;
use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Tile {
    #[key]
    entity_id: u128,
    chamber_id: u128,
    pos: u8,
    tile_type: u8,
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Door {
    #[key]
    entity_id: u128,
    chamber_id: u128,
    dir: u8,
    to_location: u128,
    open: bool,
}

