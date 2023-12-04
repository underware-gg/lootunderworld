
#[derive(Model, Copy, Drop, Serde)]
struct Tile {
    #[key]
    key_location_id: u128,
    #[key]
    key_pos: u8,
    // repeat keys to be queryable by recs
    location_id: u128,
    pos: u8,
    tile_type: u8,
}
