%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.library.grid import Grid, ns_grid
from contracts.library.triangle_element import ns_triangle_element
from contracts.library.math import ns_math

@external
func __setup__() {
    return ();
}

@external
func test_get_xsi{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let x = ns_triangle_element.get_xsi(0);
    assert x.x = 0;
    assert x.y = 0;

    let x = ns_triangle_element.get_xsi(1);
    assert x.x = 1;
    assert x.y = 0;

    let x = ns_triangle_element.get_xsi(2);
    assert x.x = 0;
    assert x.y = 1;
    return ();
}

@external
func test_coordinate_mapping{range_check_ptr}() {
    let x1 = ns_math.from_grid(Grid(3, 4));
    let x2 = ns_math.from_grid(Grid(8, -1));
    let x3 = ns_math.from_grid(Grid(-7, 10));

    let parent_1 = ns_math.from_grid(Grid(0, 0));
    let parent_2 = ns_math.from_grid(Grid(1, 0));
    let parent_3 = ns_math.from_grid(Grid(0, 1));

    let x = ns_triangle_element.coordinate_mapping(parent_1, x1, x2, x3);
    assert x.x = 3 * ns_math.FRACT_PART;
    assert x.y = 4 * ns_math.FRACT_PART;

    let x = ns_triangle_element.coordinate_mapping(parent_2, x1, x2, x3);
    assert x.x = 8 * ns_math.FRACT_PART;
    assert x.y = (-1) * ns_math.FRACT_PART;

    let x = ns_triangle_element.coordinate_mapping(parent_3, x1, x2, x3);
    assert x.x = (-7) * ns_math.FRACT_PART;
    assert x.y = 10 * ns_math.FRACT_PART;

    let temp = ns_math.from_grid(Grid(1, 1));
    let mid = ns_grid.scalar_div(temp, 2);

    let x = ns_triangle_element.coordinate_mapping(mid, x1, x2, x3);
    assert x.x = 8 * ns_math.FRACT_PART / 2 - 7 * ns_math.FRACT_PART / 2;
    assert x.y = (-1) * ns_math.FRACT_PART / 2 + 10 * ns_math.FRACT_PART / 2;
    return ();
}
