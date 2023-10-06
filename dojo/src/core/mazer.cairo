use loot_underworld::utils::bitmap::{Bitmap};
use loot_underworld::types::dir::{Dir, DirTrait};
use integer::BoundedU256;
use debug::PrintTrait;

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
// classic binary tree is not good!
// * it contains 2 full corridors (top row, left column)
// * it contains 2 paths that cross ONLY at the start (top left corner)
// * last row and colunm are not set
fn maze_binary_tree_pure(seed: u256, entry_dir: Dir) -> u256 {
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
    result
}
//
// our version fixes those problems by...
// * eliminating one empty side (lets keep the entry row for fun)
// * adding some random path tiles
fn maze_binary_tree(seed: u256, entry_dir: Dir) -> u256 {
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
        if (((x + y) % 2) == 0 && Bitmap::is_set_xy(seed, x * 2, y * 2)) {
            result = Bitmap::set_xy(result, x * 2, y * 2);
        }
        i += 1;
    };
    // rotate to keep the long row always on the entry
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
    let mut result: u256 = seed;
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
            result = Bitmap::unset(result, xx, yy - 1);
        } else {
            result = Bitmap::set_xy(result, xx, yy - 1);
            result = Bitmap::unset(result, xx - 1, yy);
        }
        i += 1;
    };
    (result)
}
