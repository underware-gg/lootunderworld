// just a structure to pass doors along
#[derive(Copy, Drop, Serde, PartialEq)]
struct Doors {
    north: u8,
    east: u8,
    west: u8,
    south: u8,
    over: u8,
    under: u8,
}
