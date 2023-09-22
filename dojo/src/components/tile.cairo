#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Tile {
    #[key]
    entity_id: u128,
    location_id: u128,
    pos: u8,
    tile_type: u8,
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Door {
    #[key]
    entity_id: u128, // same as Tile
    dir: u8,
    to_location_id: u128,
    is_open: bool,
}
