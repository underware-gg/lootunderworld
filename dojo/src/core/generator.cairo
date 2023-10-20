use traits::Into;
use debug::PrintTrait;
use loot_underworld::core::carver::{carve};
use loot_underworld::core::collapsor::{collapse};
use loot_underworld::core::connector::{connect_doors};
use loot_underworld::core::protector::{protect};
use loot_underworld::core::binary_tree::{binary_tree_classic, binary_tree_pro, binary_tree_fuzz};
use loot_underworld::core::seeder::{make_underseed, make_overseed};
use loot_underworld::types::dir::{Dir};

fn generate(
    seed: u256,
    protected: u256,
    entry_dir: Dir,
    generator_name: felt252,
    generator_value: u32,
) -> u256 {
    // the seed is the initial state, we sculpt from that
    let mut bitmap: u256 = seed;

    if(generator_name == 'seed') {
        bitmap = seed;
    } else if(generator_name == 'underseed') {
        bitmap = make_underseed(seed);
    } else if(generator_name == 'overseed') {
        bitmap = make_overseed(seed);
    } else if(generator_name == 'protected') {
        bitmap = protected;
    } else if(generator_name == 'entry') {
        // the entry is always a wide chamber
        bitmap = carve(bitmap, protected, 3);
        bitmap = carve(bitmap, protected, 7);
    } else if(generator_name == 'connection') {
        bitmap = connect_doors(protected, entry_dir, generator_value);
    } else if(generator_name == 'binary_tree_classic') {
        bitmap = binary_tree_classic(bitmap, entry_dir);
        bitmap = protect(bitmap, protected);
    } else if(generator_name == 'binary_tree_pro') {
        bitmap = binary_tree_pro(bitmap, entry_dir);
        bitmap = protect(bitmap, protected);
    } else if(generator_name == 'binary_tree_fuzz') {
        bitmap = binary_tree_fuzz(bitmap);
        bitmap = protect(bitmap, protected);
    } else if(generator_name == 'collapse') {
        let open_spaces: bool = (generator_value == 1);
        bitmap = collapse(bitmap, open_spaces);
        bitmap = protect(bitmap, protected);
    } else if(generator_name == 'carve') {
        // ex: '4' >  pass1 = 4
        // ex: '54' >  pass1 = 5, pass2 = 4
        let pass1: u32 = (generator_value / 10) % 10;
        let pass2: u32 = (generator_value) % 10;
        if(pass1 > 0) {
            bitmap = carve(bitmap, protected, pass1.try_into().unwrap());
        }
        if(pass2 > 0) {
            bitmap = carve(bitmap, protected, pass2.try_into().unwrap());
        }
    } else if(generator_name == 'collapse_carve') {
        let pass1: u32 = (generator_value) % 10;
        bitmap = collapse(bitmap, true);
        bitmap = carve(bitmap, protected, pass1.try_into().unwrap());
    } else {
        assert(false, 'Invalid generator');
    }

    bitmap
}
