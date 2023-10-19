use loot_underworld::core::seeder::{make_underseed, make_overseed};
use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::types::dir::{Dir, DirTrait};

//-------------------------------
// Binary Tree maze
//
// For each existing cell in the grid:
//  1. Get if they exist, north or west neighbors.
//  2. Toss a coin to connect with one of them.
//
// learned from:
// https://medium.com/analytics-vidhya/maze-generations-algorithms-and-visualizations-9f5e88a3ae37
// https://www.youtube.com/watch?v=BDXm568ql34&t=53s
//
// classic binary tree has some quirks!
// * it contains 2 full corridors (top row, left column)
// * it contains 2 paths that cross ONLY at the start (top left corner)
// * last row and colunm are not set
fn binary_tree_classic(seed: u256, entry_dir: Dir) -> u256 {
    let mut result: u256 = 0;
    let mut i: usize = 0;
    loop {
        if (i >= 64) { break; }
        let xx = ((i % 8) * 2);
        let yy = ((i / 8) * 2);
        let rnd = Bitmap::is_set_xy(seed, xx, yy);
        result = Bitmap::set_xy(result, xx, yy); // set self
        if (xx > 0 && (yy == 0 || rnd)) {
            result = Bitmap::set_xy(result, xx - 1, yy); // set west
        }
        if (yy > 0 && (xx == 0 || !rnd)) {
            result = Bitmap::set_xy(result, xx, yy - 1); // set north
        }
        i += 1;
    };
    // rotate to keep the long row always on the entry
    Bitmap::rotate_north_to(result, entry_dir)
}
//
// our version tries to fix those problems by...
// * eliminating one empty side (let's keep the entry row for fun)
// * adding some random path tiles
fn binary_tree_pro(seed: u256, entry_dir: Dir) -> u256 {
    let mut underseed: u256 = make_underseed(seed);
    let mut result: u256 = 0;
    let mut i: usize = 0;
    loop {
        if (i >= 64) { break; }
        let x = i % 8;
        let y = i / 8;
        let xx = (x * 2) + 1;
        let yy = (y * 2);
        let rnd = Bitmap::is_set_xy(seed, xx, yy);
        result = Bitmap::set_xy(result, xx, yy); // set self
        if (yy == 0 || rnd) {
            result = Bitmap::set_xy(result, xx - 1, yy); // set west
            if (yy == 0 && rnd) { // set last row
                result = Bitmap::set_xy(result, xx, 15);
            }
        } else {
            result = Bitmap::set_xy(result, xx, yy - 1); // set north
        }
        // open some random paths
        if (Bitmap::is_set_xy(underseed, x * 2, y * 2)) {
            result = Bitmap::set_xy(result, x * 2, y * 2);
        }
        i += 1;
    };
    // rotate to keep the long row always on the entry
    Bitmap::rotate_north_to(result, entry_dir)
}

//
// fuzzy version...
// * starts with random paths
// * |'s the core of a binary tree
fn binary_tree_fuzz(seed: u256) -> u256 {
    let mut result: u256 = make_overseed(seed);
    let mut i: usize = 0;
    loop {
        if (i >= 64) { break; }
        let x = i % 8;
        let y = i / 8;
        let xx = (x * 2) + 1;
        let yy = (y * 2) + 1;
        result = Bitmap::set_xy(result, xx, yy);
        if (Bitmap::is_set_xy(seed, xx, yy)) {
            result = Bitmap::set_xy(result, xx - 1, yy);
            result = Bitmap::unset_xy(result, xx, yy - 1);
        } else {
            result = Bitmap::set_xy(result, xx, yy - 1);
            result = Bitmap::unset_xy(result, xx - 1, yy);
        }
        i += 1;
    };
    (result)
}
