use traits::Into;
use debug::PrintTrait;
use loot_underworld::utils::hash::{hash_u128, hash_u128_to_u256};

// https://github.com/starkware-libs/cairo/blob/main/corelib/src/starknet/info.cairo
use starknet::get_block_info;

fn get_block_hash() -> u128 {
    // let block_number = get_block_number();
    // let block_timestamp = get_block_timestamp();
    let block_info = get_block_info().unbox();
    hash_u128(block_info.block_number.into(), block_info.block_timestamp.into())
}

fn make_seed(realm_id: u128, location: u128) -> u256 {
    _make_seed(realm_id, location, get_block_hash())
}

fn _make_seed(realm_id: u128, location: u128, block_hash: u128) -> u256 {
    let h1 = hash_u128(realm_id, location);
    let h2 = hash_u128(h1, block_hash);
    hash_u128_to_u256(h2)
}

fn make_underseed(seed: u256) -> u256 {
    let h = hash_u128(seed.low, seed.high);
    seed & hash_u128_to_u256(h)
}

fn make_overseed(seed: u256) -> u256 {
    let h = hash_u128(seed.low, seed.high);
    seed | hash_u128_to_u256(h)
}


//------------------------------------
// Unit test_make_seed
//
use loot_underworld::utils::bitwise::{U256Bitwise};

#[test]
#[available_gas(100_000)]
fn test_get_block_hash() {
    let h = get_block_hash();
    // h.print()
    assert(h != 0, 'block hash');
}


#[test]
#[available_gas(100_000_000)]
fn test_make_seed() {
    let s1 = _make_seed(1, 1, 1);
    let s2 = _make_seed(1, 1, 2);
    let s3 = _make_seed(1, 2, 1);
    let s4 = _make_seed(1, 2, 2);
    let s5 = _make_seed(2, 1, 1);
    let s6 = _make_seed(2, 1, 2);
    let s7 = _make_seed(2, 2, 1);
    let s8 = _make_seed(2, 2, 2);
    assert(s1.low !=s1.high, 's1 h/l');
    assert(s2.low !=s2.high, 's2 h/l');
    assert(s3.low !=s3.high, 's3 h/l');
    assert(s4.low !=s4.high, 's4 h/l');
    assert(s5.low !=s5.high, 's5 h/l');
    assert(s6.low !=s6.high, 's6 h/l');
    assert(s7.low !=s7.high, 's7 h/l');
    assert(s8.low !=s8.high, 's8 h/l');
    assert(s1!=s2 && s1!=s3 && s1!=s4 && s1!=s5 && s1!=s6 && s1!=s7 && s1!=s8, 's1');
    assert(s2!=s1 && s2!=s3 && s2!=s4 && s2!=s5 && s2!=s6 && s2!=s7 && s2!=s8, 's2');
    assert(s3!=s1 && s3!=s2 && s3!=s4 && s3!=s5 && s3!=s6 && s3!=s7 && s3!=s8, 's3');
    assert(s4!=s1 && s4!=s2 && s4!=s3 && s4!=s5 && s4!=s6 && s4!=s7 && s4!=s8, 's4');
    assert(s5!=s1 && s5!=s2 && s5!=s3 && s5!=s4 && s5!=s6 && s5!=s7 && s5!=s8, 's5');
    assert(s6!=s1 && s6!=s2 && s6!=s3 && s6!=s4 && s6!=s5 && s6!=s7 && s6!=s8, 's6');
    assert(s7!=s1 && s7!=s2 && s7!=s3 && s7!=s4 && s7!=s5 && s7!=s6 && s7!=s8, 's7');
    assert(s8!=s1 && s8!=s2 && s8!=s3 && s8!=s4 && s8!=s5 && s8!=s6 && s8!=s7, 's8');
}

#[test]
#[available_gas(1_000_000_000)]
fn test_under_over_seed() {
    let mut n: usize = 0;
    loop {
        if n == 8 { break; }
        let seed = _make_seed(1, 2, 3);
        let under = make_underseed(seed);
        let over = make_overseed(seed);
        assert(U256Bitwise::count_bits(under) < U256Bitwise::count_bits(seed), 'under < seed');
        assert(U256Bitwise::count_bits(seed) < U256Bitwise::count_bits(over), 'seed < over');
        n += 1;
    };
}
