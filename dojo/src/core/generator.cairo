use traits::Into;
use debug::PrintTrait;
use loot_underworld::core::carver::{carve};
use loot_underworld::core::collapsor::{collapse};
use loot_underworld::core::mazer::{maze_binary_tree, maze_binary_fuzz};
use loot_underworld::core::protector::{protect};
use loot_underworld::types::dir::{Dir};

fn generate(seed: u256, protected: u256, algo: u128, entry_dir: Dir) -> u256 {

    let mut bitmap: u256 = seed;
    let mut postProtect: bool = false;

    if(algo == 1) {
        bitmap = collapse(bitmap, false);
        postProtect = true;
    } else if(algo == 2) {
        bitmap = collapse(bitmap, true);
        postProtect = true;
    } else if(algo == 10) {
        bitmap = maze_binary_tree(bitmap, entry_dir);
        postProtect = true;
    } else if(algo == 11) {
        bitmap = maze_binary_fuzz(bitmap, protected);
        postProtect = true;
    } else if(algo > 90 && algo < 100) {
        let pass1: u128 = algo % 10;
        bitmap = collapse(bitmap, true);
        bitmap = carve(bitmap, protected, pass1.try_into().unwrap());
    } else if(algo > 100 && algo < 200) {
        let pass1: u128 = (algo - 100) / 10;
        let pass2: u128 = (algo - 100) % 10;
        if(pass1 > 0) {
            bitmap = carve(bitmap, protected, pass1.try_into().unwrap());
        }
        if(pass2 > 0) {
            bitmap = carve(bitmap, protected, pass2.try_into().unwrap());
        }
    } else {
        postProtect = true;
    }

    // only needed if not using carve()
    if(postProtect) {
        bitmap = protect(bitmap, protected);
    }

    bitmap
}
