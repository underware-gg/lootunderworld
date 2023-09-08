use array::ArrayTrait;
use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde)]
struct Chamber {
    #[key]
    realm_id: u128,
    #[key]
    coord: u128,
    seed: u256,
    // bitmap: u256,
}
