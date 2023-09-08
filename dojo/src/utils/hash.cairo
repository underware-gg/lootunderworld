use traits::Into;
use debug::PrintTrait;

// https://github.com/starkware-libs/cairo/blob/main/corelib/src/integer.cairo
use integer::{u128s_from_felt252, U128sFromFelt252Result};

// https://github.com/starkware-libs/cairo/blob/main/corelib/src/pedersen.cairo
// externals usage:
// https://github.com/shramee/starklings-cairo1/blob/main/corelib/src/hash.cairo
extern fn pedersen(a: felt252, b: felt252) -> felt252 implicits(Pedersen) nopanic;

//
// hash based on: 
// https://github.com/shramee/cairo-random/blob/main/src/hash.cairo
//

// Full random felt
fn hash_felt(seed: felt252, offset: felt252) -> felt252 {
    pedersen(seed, offset)
}

// Random u128
// https://github.com/smartcontractkit/chainlink-starknet/blob/develop/contracts/src/utils.cairo
fn hash_u128(seed: u128, offset: u128) -> u128 {
    let hash = hash_felt(seed.into(), offset.into());
    match u128s_from_felt252(hash) {
        U128sFromFelt252Result::Narrow(x) => x,
        U128sFromFelt252Result::Wide((_, x)) => x,
    }
}

// retruns the hashed number mod'ded to min .. max (non inclusive)
fn hash_128_range(seed: u128, offset: u128, min: u128, max: u128) -> u128 {
    let rnd = hash_u128(seed, offset);
    let range = max - min + 1;
    min + rnd % range
}

#[test]
// #[available_gas(20000)]
fn test_hash_felt() {
    let rnd0  = hash_felt(25, 1);
    let rnd1  = hash_felt(25, 1);
    let rnd12 = hash_felt(25, 2);
    let rnd2  = hash_felt(26, 1);
    let rnd22 = hash_felt(26, 2);
    assert(rnd0 == 0x7f25249bc3b57d4a9cb82bd75d25579ab9d03074bff6ee2d4dbc374dbf3f846, '');
    assert(rnd0 == rnd1, '');
    assert(rnd1 != rnd12, '');
    assert(rnd1 != rnd2, '');
    assert(rnd2 != rnd22, '');
}

#[test]
// #[available_gas(20000)]
fn test_hash_u128() {
    let rnd0  = hash_u128(25, 1);
    let rnd1  = hash_u128(25, 1);
    let rnd12 = hash_u128(25, 2);
    let rnd2  = hash_u128(26, 1);
    let rnd22 = hash_u128(26, 2);
    // rnd.print();
    assert(rnd0 == 0xab9d03074bff6ee2d4dbc374dbf3f846, '');
    assert(rnd0 == rnd1, '');
    assert(rnd1 != rnd12, '');
    assert(rnd1 != rnd2, '');
    assert(rnd2 != rnd22, '');
}

#[test]
#[available_gas(1000000)]
fn test_hash_range_u128() {
    assert(0x2 == hash_128_range(4, 1, 1, 9), '');
    assert(0x6 == hash_128_range(5, 1, 1, 9), '');
    assert(0x4 == hash_128_range(6, 1, 1, 9), '');
    assert(0x3 == hash_128_range(7, 1, 1, 9), '');

    let mut i: u128 = 0;
    let mut h: u128 = 0;
    loop {
        if i > 15 { break; }
        h = hash_128_range(25, i, 2, 2); 
        assert(h == 2, 'not == 2');
        h = hash_128_range(25, i, 2, 5); 
        assert(h >= 2, 'not >= 2');
        assert(h <= 5, 'not <= 5');
        i += 1;
    }
}
