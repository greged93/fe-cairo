%lang starknet

from starkware.cairo.common.math import assert_le, signed_div_rem, abs_value, sign
from contracts.library.grid import ns_grid, Grid

namespace ns_math {
    const INT_PART = 2 ** 105;
    const FRACT_PART = 10 ** 6;
    const BOUND = 2 ** 125;
    const ONE = 1 * FRACT_PART;

    func assert_valid{range_check_ptr}(x: felt) {
        assert_le(x, BOUND);
        assert_le(-BOUND, x);
        return ();
    }

    // Converts a fixed point value to a felt, truncating the fractional component
    func to_felt{range_check_ptr}(x: felt) -> felt {
        let (res, _) = signed_div_rem(x, FRACT_PART, BOUND);
        return res;
    }

    // Converts a felt to a fixed point value ensuring it will not overflow
    func from_felt{range_check_ptr}(x: felt) -> felt {
        assert_le(x, INT_PART);
        assert_le(-INT_PART, x);
        return x * FRACT_PART;
    }

    // Converts a fixed point value to a Grid, truncating the fractional component
    func to_grid{range_check_ptr}(x: Grid) -> Grid {
        let (res_x, _) = signed_div_rem(x.x, FRACT_PART, BOUND);
        let (res_y, _) = signed_div_rem(x.y, FRACT_PART, BOUND);
        let x = Grid(res_x, res_y);
        return x;
    }

    // Converts a Grid to a fixed point value ensuring it will not overflow
    func from_grid{range_check_ptr}(x: Grid) -> Grid {
        assert_le(x.x, INT_PART);
        assert_le(-INT_PART, x.x);
        assert_le(x.y, INT_PART);
        assert_le(-INT_PART, x.y);
        return ns_grid.scalar_mul(x, FRACT_PART);
    }

    // Convenience addition method to assert no overflow before returning
    func add{range_check_ptr}(x: felt, y: felt) -> felt {
        let res = x + y;
        assert_valid(res);
        return res;
    }

    // Convenience subtraction method to assert no overflow before returning
    func sub{range_check_ptr}(x: felt, y: felt) -> felt {
        let res = x - y;
        assert_valid(res);
        return res;
    }

    // Multiples two fixed point values and checks for overflow before returning
    func mul{range_check_ptr}(x: felt, y: felt) -> felt {
        tempvar product = x * y;
        let (res, _) = signed_div_rem(product, FRACT_PART, BOUND);
        assert_valid(res);
        return res;
    }

    // Divides two fixed point values and checks for overflow before returning
    // Both values may be signed (i.e. also allows for division by negative b)
    func div{range_check_ptr}(x: felt, y: felt) -> felt {
        alloc_locals;
        let div = abs_value(y);
        let div_sign = sign(y);
        tempvar product = x * FRACT_PART;
        let (res_u, _) = signed_div_rem(product, div, BOUND);
        assert_valid(res_u);
        return res_u * div_sign;
    }
}
