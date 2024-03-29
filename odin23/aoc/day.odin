//+private file
// +build ignore
package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 0

@(private)
dayXX :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	return part1, part2
}

test_input :: ``

// @(test, private)
test_example_dXX_p1 :: proc(t: ^testing.T) {
	part1, _ := dayXX(test_input)
	part1_expected := int(0)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

// @(test, private)
test_example_dXX_p2 :: proc(t: ^testing.T) {
	_, part2 := dayXX(test_input)
	part2_expected := int(0)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_dayXX :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_dayXX :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = dayXX(string(options.input))
	}
	options.count = options.rounds
	return nil
}
