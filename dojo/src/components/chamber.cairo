use array::ArrayTrait;
use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde)]
struct Chamber {
    #[key]
    entity_id: u128,
    realm_id: u128,
    coord: u128,
    seed: u256,
}

#[derive(Component, Copy, Drop, Serde)]
struct Map {
    #[key]
    entity_id: u128,
    bitmap: u256,
}
