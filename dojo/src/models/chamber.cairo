use starknet::ContractAddress;
use dojo::database::schema::{
    Enum, Member, Ty, Struct, SchemaIntrospection, serialize_member, serialize_member_type
};

// A geographic placed Chamber
// (Immutable)
#[derive(Model, Copy, Drop, Serde)]
struct Chamber {
    #[key]
    location_id: u128,
    seed: u256,
    minter: ContractAddress,
    domain_id: u16,
    token_id: u16,
    yonder: u16,
}

// A Chamber's map information
// (Immutable)
#[derive(Model, Copy, Drop, Serde)]
struct Map {
    #[key]
    entity_id: u128,
    bitmap: u256, // the actual map: 0=void/walls, 1=path
    generator_name: felt252,
    generator_value: u32,
    // doors positions
    north: u8,
    east: u8,
    west: u8,
    south: u8,
    over: u8,
    under: u8,
}

// The current conditions of a Chamebr
// (Mutable)
#[derive(Model, Copy, Drop, Serde)]
struct State {
    #[key]
    location_id: u128,
    light: u8,
    threat: u8,
    wealth: u8,
}
