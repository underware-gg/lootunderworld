use array::ArrayTrait;
use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Chamber {
    #[key]
    entity_id: u128,
    realm_id: u128,
    location: u128,
    seed: u256,
    minter: ContractAddress,
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Map {
    #[key]
    entity_id: u128,
    bitmap: u256,
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Door {
    #[key]
    entity_id: u128,
    #[key]
    dir: u8,
    pos: u8,
    toLocation: u128,
}

