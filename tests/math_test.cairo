%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.library.grid import Grid
from contracts.library.math import ns_math

@external
func __setup__() {
    return ();
}

@external
func test_from_grid{range_check_ptr}() {
    let x = Grid(1, 2);
    let x = ns_math.from_grid(x);

    assert x.x = 1000000;
    assert x.y = 2000000;
    return ();
}

@external
func test_from_grid_max_x{range_check_ptr}() {
    %{ expect_revert() %}
    let x = Grid(ns_math.INT_PART + 1, 2);
    let x = ns_math.from_grid(x);
    return ();
}

@external
func test_from_grid_min_x{range_check_ptr}() {
    %{ expect_revert() %}
    let x = Grid((-ns_math.INT_PART) - 1, 2);
    let x = ns_math.from_grid(x);
    return ();
}

@external
func test_from_grid_max_y{range_check_ptr}() {
    %{ expect_revert() %}
    let x = Grid(3, ns_math.INT_PART + 1);
    let x = ns_math.from_grid(x);
    return ();
}

@external
func test_from_grid_min_y{range_check_ptr}() {
    %{ expect_revert() %}
    let x = Grid(6, (-ns_math.INT_PART) - 1);
    let x = ns_math.from_grid(x);
    return ();
}

@external
func test_to_grid{range_check_ptr}() {
    let x = Grid(1, 2);
    let x = ns_math.from_grid(x);
    let x = ns_math.to_grid(x);

    assert x.x = 1;
    assert x.y = 2;
    return ();
}
