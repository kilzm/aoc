package aoc

import "core:strconv"

rune_to_int :: proc(c: rune) -> int {
	return int(c) - 48
}

read_u64 :: proc(str: string) -> (result: u64) {
    result, _ = strconv.parse_u64_of_base(str, 10)
    return
}

read_i64 :: proc(str: string) -> (result: i64) {
    result, _ = strconv.parse_i64_of_base(str, 10)
    return
}

ipow :: proc(base: int, exp: u32) -> (res: int) {
    res = 1
    exp_ := exp
    base_ := base
    for exp_ != 0 {
        if exp_ & 1 != 0 do res *= base_
        exp_ >>= 1
        base_ *= base_
    }
    return
}
