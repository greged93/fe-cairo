%lang starknet

from starkware.cairo.common.math import signed_div_rem

struct Grid {
    x: felt,
    y: felt,
}

namespace ns_grid {
    const GRID_SIZE = 2;

    func scalar_mul{range_check_ptr}(x_y: Grid, constant: felt) -> Grid {
        let res = Grid(x_y.x * constant, x_y.y * constant);
        return res;
    }

    func scalar_div{range_check_ptr}(x_y: Grid, constant: felt) -> Grid {
        const BOUND = 2 ** 127;
        let (res_x, _) = signed_div_rem(x_y.x, constant, BOUND);
        let (res_y, _) = signed_div_rem(x_y.y, constant, BOUND);
        let res = Grid(res_x, res_y);
        return res;
    }
}
