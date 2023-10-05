use loot_underworld::utils::bitwise::{U256Bitwise};
use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::types::dir::{Dir, DirTrait};
use integer::BoundedU256;

//-------------------------------
// Binary Tree maze
//
// For each existing cell in the grid:
//  1. Get if they exist, north or west neighbors.
//  2. Toss a coin to connect with one of them.
//
// learned from:
// https://medium.com/analytics-vidhya/maze-generations-algorithms-and-visualizations-9f5e88a3ae37
//
fn maze_binary_tree(seed: u256, entry_dir: Dir) -> u256 {
    let mut result: u256 = 0;
    let mut i: usize = 0;
    loop {
        if (i >= 64) { break; }
        let x = i % 8;
        let y = i / 8;
        let xx = (x * 2) + 1;
        let yy = (y * 2);
        let ii = (yy * 16) + xx;
        let rnd = U256Bitwise::isSet(seed, 255 - ii);
        // set self
        result = U256Bitwise::set(result, ii);
        if (yy == 0 || rnd) {
            // set west
            result = U256Bitwise::set(result, (yy * 16) + xx - 1);
            // set last row
            if (yy == 0 && rnd) {
                result = U256Bitwise::set(result, (15 * 16) + xx);
            }
        } else {
            // set north
            result = U256Bitwise::set(result, ((yy - 1) * 16) + xx);
        }
        i += 1;
    };
    // return rotated to entry door
    match entry_dir {
        Dir::North => result,
        Dir::East => Bitmap::Rotate90CW(result),
        Dir::West => Bitmap::Rotate90CCW(result),
        Dir::South => Bitmap::Rotate180(result),
        Dir::Over => result,
        Dir::Under => result,
    }
}

fn maze_binary_fuzz(seed: u256, protected: u256) -> u256 {
    // let mut result: u256 = BoundedU256::max();
    let mut result: u256 = seed;
    let mut i: usize = 0;
    loop {
        if (i >= 64) { break; }
        let x: usize = i % 8;
        let y: usize = i / 8;
        let xx = (x * 2) + 1;
        let yy = (y * 2) + 1;
        let ii = (yy * 16) + xx;
        result = U256Bitwise::set(result, ii);
        if (U256Bitwise::isSet(seed, 255 - ii)) {
            result = U256Bitwise::set(result, (yy * 16) + xx - 1);
            result = U256Bitwise::unset(result, ((yy - 1) * 16) + xx);
        } else {
            result = U256Bitwise::set(result, ((yy - 1) * 16) + xx);
            result = U256Bitwise::unset(result, (yy * 16) + xx - 1);
        }
        i += 1;
    };
    (result)
}
