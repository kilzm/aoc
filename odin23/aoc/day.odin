package aoc

import "core:fmt"
import "core:strings"
import "core:testing"

dayXX :: proc(content: string) -> (result_t, result_t) {
	part1, part2: int
	return part1, part2
}


test_input :: ""

// @(test)
test_example_dXX_p1 :: proc(t: ^testing.T) {
	part1, _ := dayXX(test_input)
	part1_expected := int(0)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

// @(test)
test_example_dXX_p2 :: proc(t: ^testing.T) {
	_, part2 := dayXX(test_input)
	part2_expected := int(0)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}
