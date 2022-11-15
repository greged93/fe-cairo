%lang starknet

from starkware.cairo.common.registers import get_label_location
from contracts.library.grid import ns_grid, Grid
from contracts.library.math import ns_math

namespace ns_triangle_element {
    // @notice Returns the coordinates of the parent element
    // @param index The index of the parent element
    // @return The parent element coordinates
    func get_xsi(index: felt) -> Grid {
        let (data_address) = get_label_location(xsi);
        let address = data_address + index * ns_grid.GRID_SIZE;
        let x = Grid([address], [address + 1]);
        return x;

        xsi:
        dw 0;
        dw 0;
        dw 1;
        dw 0;
        dw 0;
        dw 1;
    }

    // @notice Maps the position from the parent element to the child element
    // @param eta The position on the parent element (precision: 6)
    // @param x1 The coordinates of the triangle's first summit (precision: 6)
    // @param x2 The coordinates of the triangle's second summit (precision: 6)
    // @param x3 The coordinates of the triangle's third summit (precision: 6)
    // @return The mapped coordinates from the parent to the child element (precision: 6)
    func coordinate_mapping{range_check_ptr}(eta: Grid, x1: Grid, x2: Grid, x3: Grid) -> Grid {
        tempvar x = ns_math.mul(ns_math.ONE - eta.x - eta.y, x1.x) + ns_math.mul(eta.x, x2.x) + ns_math.mul(eta.y, x3.x);
        tempvar y = ns_math.mul(ns_math.ONE - eta.x - eta.y, x1.y) + ns_math.mul(eta.x, x2.y) + ns_math.mul(eta.y, x3.y);
        let res = Grid(x, y);
        return res;
    }
}
