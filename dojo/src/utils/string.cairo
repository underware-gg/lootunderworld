// use array::ArrayTrait;
use debug::PrintTrait;
use loot_underworld::utils::bitwise::{U256Bitwise};

fn concat(left: felt252, right: felt252) -> felt252 {
    let _left: u256 = left.into();
    let _right: u256 = right.into();
    let mut offset: usize = 0;
    let mut i: usize = 0;
    loop {
        if(i == 256) { break; }
        if(_right & U256Bitwise::shl(0xff, i) != 0) {
            offset = i + 8;
        }
        i += 8;
    };
    (_right | U256Bitwise::shl(_left, offset)).try_into().unwrap()
}

fn join(left: felt252, right: felt252) -> felt252 {
    concat(concat(left, '_'), right)
}


//----------------------------------------
// Unit  tests
//
#[test]
#[available_gas(100_000_000)]
fn test_string_concat() {
    assert(concat('ABC', '123') == 'ABC123', 'ABC123');
    assert(concat('Hello ', 'World') == 'Hello World', 'Hello 1');
    assert(concat('Hello', ' World') == 'Hello World', 'Hello 2');
    assert(concat(' Hello', 'World ') == ' HelloWorld ', 'Hello 3');
    assert(concat(' Hello ', ' World ') == ' Hello  World ', 'Hello 4');
    assert(join('Hello', 'World') == 'Hello_World', 'Hello_World');
}
