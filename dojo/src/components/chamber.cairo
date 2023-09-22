use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Chamber {
    #[key]
    location_id: u128,
    seed: u256,
    minter: ContractAddress,
    domain_id: u16,
    token_id: u16,
    yonder: u16,
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Map {
    #[key]
    entity_id: u128,
    bitmap: u256,       // the actual map: 0=void/walls, 1=path
    protected: u256,    // occupied tiles: 0=free, 1=occupied
}

// Used by generator to match doors from chamber to chamber
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct ChamberDoors {
    #[key]
    location_id: u128,
    north: u8,
    east: u8,
    west: u8,
    south: u8,
    over: u8,
    under: u8,
}
