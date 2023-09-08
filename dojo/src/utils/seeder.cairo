use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::hash::{hash_u128, hash_u128_to_u256};

fn make_seed(realm_id: u128, coord: u128, block_hash: u128) -> u256 {
    let h1 = hash_u128(realm_id, coord);
    let h2 = hash_u128(h1, block_hash);
    hash_u128_to_u256(h2)
}

#[test]
// #[available_gas(1000000)]
fn test_make_seed() {
    let s1 = make_seed(1, 1, 1);
    let s2 = make_seed(1, 1, 2);
    let s3 = make_seed(1, 2, 1);
    let s4 = make_seed(1, 2, 2);
    let s5 = make_seed(2, 1, 1);
    let s6 = make_seed(2, 1, 2);
    let s7 = make_seed(2, 2, 1);
    let s8 = make_seed(2, 2, 2);
    assert(s1!=s2 && s1!=s3 && s1!=s4 && s1!=s5 && s1!=s6 && s1!=s7 && s1!=s8, 's1');
    assert(s2!=s1 && s2!=s3 && s2!=s4 && s2!=s5 && s2!=s6 && s2!=s7 && s2!=s8, 's2');
    assert(s3!=s1 && s3!=s2 && s3!=s4 && s3!=s5 && s3!=s6 && s3!=s7 && s3!=s8, 's3');
    assert(s4!=s1 && s4!=s2 && s4!=s3 && s4!=s5 && s4!=s6 && s4!=s7 && s4!=s8, 's4');
    assert(s5!=s1 && s5!=s2 && s5!=s3 && s5!=s4 && s5!=s6 && s5!=s7 && s5!=s8, 's5');
    assert(s6!=s1 && s6!=s2 && s6!=s3 && s6!=s4 && s6!=s5 && s6!=s7 && s6!=s8, 's6');
    assert(s7!=s1 && s7!=s2 && s7!=s3 && s7!=s4 && s7!=s5 && s7!=s6 && s7!=s8, 's7');
    assert(s8!=s1 && s8!=s2 && s8!=s3 && s8!=s4 && s8!=s5 && s8!=s6 && s8!=s7, 's8');
}
