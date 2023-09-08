use array::ArrayTrait;
use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde)]
struct Seed {
    #[key]
    realm_id: u128,
    #[key]
    coord: u128,
    seed: u256,
}

#[derive(Component, Copy, Drop, Serde)]
struct Map {
    #[key]
    realm_id: u128,
    #[key]
    coord: u128,
    bitmap: u256,
}
