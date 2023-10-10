use traits::Into;
use debug::PrintTrait;
use loot_underworld::core::carver::{carve};
use loot_underworld::core::collapsor::{collapse};
use loot_underworld::core::connector::{connect_doors};
use loot_underworld::core::protector::{protect};
use loot_underworld::core::mazer::{maze_binary_tree_classic, maze_binary_pro, maze_binary_fuzz};
use loot_underworld::core::seeder::{make_underseed, make_overseed};
use loot_underworld::types::dir::{Dir};

fn generate(seed: u256, mut protected: u256, algo: u128, entry_dir: Dir) -> u256 {

    let mut bitmap: u256 = seed;
    let mut postProtect: bool = true;

    if(algo == 0) {
        bitmap = seed;
    } else if(algo == 1) {
        bitmap = make_underseed(seed);
    } else if(algo == 2) {
        bitmap = make_overseed(seed);
    } else if(algo == 3) {
        bitmap = protected;
    } else if(algo == 10) {
        bitmap = collapse(bitmap, false);
    } else if(algo == 11) {
        bitmap = collapse(bitmap, true);
    } else if(algo == 20) {
        bitmap = maze_binary_tree_classic(bitmap, entry_dir);
    } else if(algo == 21) {
        bitmap = maze_binary_pro(bitmap, entry_dir);
    } else if(algo == 22) {
        bitmap = maze_binary_fuzz(bitmap, protected);
    } else if(algo >= 50 && algo <= 59) {
        let style: u128 = algo % 10;
        let (_bitmap, _protected) = connect_doors(bitmap, protected, entry_dir, style);
        bitmap = _bitmap;
        protected = _protected;
        postProtect = false;
    } else if(algo >= 90 && algo <= 99) {
        let pass1: u128 = algo % 10;
        bitmap = collapse(bitmap, true);
        bitmap = carve(bitmap, protected, pass1.try_into().unwrap());
        postProtect = false;
    } else if(algo >= 100 && algo <= 199) {
        let pass1: u128 = (algo - 100) / 10;
        let pass2: u128 = (algo - 100) % 10;
        if(pass1 > 0) {
            bitmap = carve(bitmap, protected, pass1.try_into().unwrap());
        }
        if(pass2 > 0) {
            bitmap = carve(bitmap, protected, pass2.try_into().unwrap());
        }
        postProtect = false;
    } else {
        bitmap = 0;
    }

    // only needed if not using carve()
    if (postProtect) {
        bitmap = protect(bitmap, protected);
    }

    bitmap
}
