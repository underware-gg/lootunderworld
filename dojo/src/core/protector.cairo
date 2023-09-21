use loot_underworld::utils::bitwise::{U256Bitwise};

/// @notice Create space around protected areas
/// @param bitmap The original bitmap
/// @param protected Bitmap of protected tiles
/// @return result The resultimg bitmap
fn protect(bitmap: u256, protected: u256) -> u256 {
    let mut result: u256 = bitmap;
    let mut i: usize = 0;
    loop {
        if i >= 256 { break; }
        let bit: u256 = U256Bitwise::bit(i);
        if (protected & bit) != 0 {
            result = U256Bitwise::set(result, i);
            let x = (i % 16);
            let y = (i / 16);
            if(y > 0) {
                result = U256Bitwise::set(result, i - 16);
            }
            if(y < 15) {
                result = U256Bitwise::set(result, i + 16);
            }
            if(x > 0) {
                result = U256Bitwise::set(result, i - 1);
                if(y > 0) {
                    result = U256Bitwise::set(result, i - 1 - 16);
                }
                if(y < 15) {
                    result = U256Bitwise::set(result, i - 1 + 16);
                }
            }
            if(x < 15) {
                result = U256Bitwise::set(result, i + 1);
                if(y > 0) {
                    result = U256Bitwise::set(result, i + 1 - 16);
                }
                if(y < 15) {
                    result = U256Bitwise::set(result, i + 1 + 16);
                }
            }

        }
        i += 1;
    };
    result
}


// #[test]
// #[available_gas(60_000_000)]
// fn test_carve() {
//     let seed = make_seed(1234, 5678);
//     let bitmap = carve(seed, 0, 5);
//     assert(seed != bitmap, '');
// }
