%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.library.grid import ns_grid, Grid

@external
func __setup__() {
    return ();
}

@external
func test_grid_mul{range_check_ptr}() {
    const multiplier = 5;
    tempvar grid = Grid(3, 7);
    let res = ns_grid.scalar_mul(grid, multiplier);

    assert res.x = 15;
    assert res.y = 35;
    return ();
}

@external
func test_grid_div{range_check_ptr}() {
    const divider = 5;
    tempvar grid = Grid(500, 341);
    let res = ns_grid.scalar_div(grid, divider);

    assert res.x = 100;
    assert res.y = 68;
    return ();
}
