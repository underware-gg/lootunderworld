use array::ArrayTrait;
use debug::PrintTrait;

// trait ArrayTrait<T>  {
//     fn create() -> Array<T>;
// }

fn create_array<T, impl TDrop: Drop<T>, impl TCopy: Copy<T>>(size: usize, default_value: T) -> Array::<T> {
    let mut result: Array<T> = ArrayTrait::new();
    let mut i: usize = 0;
    loop {
        if(i >= size) { break; }
        result.append(default_value);
        i += 1;
    };
    result
}

//----------------------------------------
// Unit  tests
//
#[test]
#[available_gas(1000000)]
fn test_create_array_u8() {
    let arr0 = create_array(0, 1_u8);
    let arr1 = create_array(5, 255_u8);
    // test sizes
    assert(arr0.len() == 0, 'array 0 size');
    assert(arr1.len() == 5, 'array 1 size');
    // test default values
    let mut i: usize = 0;
    loop {
        if(i >= arr1.len()) { break; }
        assert(*arr1[i] == 255_u8, 'array 1 value');
        i += 1;
    };
}
