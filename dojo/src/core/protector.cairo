use loot_underworld::utils::bitmap::{Bitmap, MASK};

// a 3x3 square on the top left corner, bitmap xy: (1, 1)
const SPOT: u256 = 0xe000e000e0000000000000000000000000000000000000000000000000000000;

/// @notice Create space around protected areas
/// @param bitmap The original bitmap
/// @param protected Bitmap of protected tiles
/// @return result The resultimg bitmap
fn protect(bitmap: u256, protected: u256) -> u256 {
    if(protected == 0) {
        return bitmap;
    }
    let mut result: u256 = bitmap;
    let mut i: usize = 0;
    loop {
        if i >= 256 { break; }
        if (Bitmap::is_set_tile(protected, i)) {
            let (x, y): (usize, usize) = Bitmap::tile_to_xy(i);
            let mut mask = SPOT;
            if (y == 0) {
                mask = Bitmap::shift_up(mask & ~MASK::TOP_ROW, 1); // no overflow
            } else if (y > 1) {
                mask = Bitmap::shift_down(mask, y - 1);
            }
            if (x == 0) {
                mask = Bitmap::shift_left(mask & ~MASK::LEFT_COL, 1); // no overflow
            } else if (x > 1) {
                mask = Bitmap::shift_right(mask, x - 1);
                if (x == 15) {
                    mask = mask & ~MASK::LEFT_COL; // remove wrapped column
                }
            }
            result = result | mask;
        }
        i += 1;
    };
    result
}


//----------------------------------------------
// Unit tests
//
// use debug::PrintTrait;

#[test]
#[available_gas(1_000_000_000)]
fn test_protect() {
    let bitmap = 0x0;
    let protect = 0x8801000000000000800000000800000000010000000000000000000000008041;
    let expected = 0xdc03dc030000c000c000dc001c001c03000300030000000000000000c0e3c0e3;
    let result = protect(bitmap, protect);
    assert(result == expected, 'protect incorrect');
}
