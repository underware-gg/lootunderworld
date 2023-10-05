#[cfg(test)]
mod tests {
    use loot_underworld::core::protector::{protect};
    use loot_underworld::utils::bitwise::{U256Bitwise};
    use loot_underworld::utils::bitmap::{Bitmap};
    use loot_underworld::types::dir::{Dir};
    use debug::PrintTrait;

    fn bitsetter(bitmap: u256, x: usize, y: usize) -> u256 {
        let mut result = bitmap;
        result = Bitmap::set_xy(result, x, y);
        if(x > 0)            { result = Bitmap::set_xy(result, x-1, y); }
        if(x < 15)           { result = Bitmap::set_xy(result, x+1, y); }
        if(y > 0)            { result = Bitmap::set_xy(result, x, y-1); }
        if(y < 15)           { result = Bitmap::set_xy(result, x, y+1); }
        if(x > 0 && y > 0)   { result = Bitmap::set_xy(result, x-1, y-1); }
        if(x < 15 && y < 15) { result = Bitmap::set_xy(result, x+1, y+1); }
        if(x > 0 && y < 15)  { result = Bitmap::set_xy(result, x-1, y+1); }
        if(x < 15 && y > 0)  { result = Bitmap::set_xy(result, x+1, y-1); }
        result
    }

    #[test]
    #[available_gas(1_000_000_000)]
    fn test_location_equality() {
        let mut protect: u256 = 0;
        let mut expected: u256 = 0;
        let mut protect_count: usize = 0;
        let mut expected_count: usize = 0;
        // corners
        protect = Bitmap::set_xy(protect, 0, 0); protect_count += 1;
        protect = Bitmap::set_xy(protect, 15, 0); protect_count += 1;
        protect = Bitmap::set_xy(protect, 0, 15); protect_count += 1;
        protect = Bitmap::set_xy(protect, 15, 15); protect_count += 1;
        expected = bitsetter(expected, 0, 0); expected_count += 4;
        expected = bitsetter(expected, 15, 0); expected_count += 4;
        expected = bitsetter(expected, 0, 15); expected_count += 4;
        expected = bitsetter(expected, 15, 15); expected_count += 4;
        // borders
        protect = Bitmap::set_xy(protect, 8, 0); protect_count += 1;
        protect = Bitmap::set_xy(protect, 0, 6); protect_count += 1;
        protect = Bitmap::set_xy(protect, 15, 7); protect_count += 1;
        protect = Bitmap::set_xy(protect, 8, 15); protect_count += 1;
        expected = bitsetter(expected, 8, 0); expected_count += 6;
        expected = bitsetter(expected, 0, 6); expected_count += 6;
        expected = bitsetter(expected, 15, 7); expected_count += 6;
        expected = bitsetter(expected, 8, 15); expected_count += 6;
        // centers
        protect = Bitmap::set_xy(protect, 5, 5); protect_count += 1;
        protect = Bitmap::set_xy(protect, 12, 12); protect_count += 1;
        expected = bitsetter(expected, 5, 5); expected_count += 9;
        expected = bitsetter(expected, 12, 12); expected_count += 9;

        assert(U256Bitwise::count_bits(protect) == protect_count, 'protect_count');
        assert(U256Bitwise::count_bits(expected) == expected_count, 'expected_count');

        let protected = protect(0, protect);
        assert(protected == expected, 'protected');
    }

}
