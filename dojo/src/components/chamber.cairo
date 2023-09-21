use array::ArrayTrait;
use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Chamber {
    #[key]
    chamber_id: u128,
    seed: u256,
    minter: ContractAddress,
    domain_id: u16,
    token_id: u16,
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Map {
    #[key]
    entity_id: u128,
    bitmap: u256,
}
