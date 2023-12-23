package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 13

day13 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	it := input[:len(input) - 1]
	for chunk in strings.split_iterator(&it, "\n\n") {
		pattern := strings.split_lines(chunk)
		defer delete(pattern)
		rows, cols := len(pattern), len(pattern[0])
		smudge, no_smudge := score_pattern(pattern, rows, cols)
		part1, part2 = part1 + smudge, part2 + no_smudge
	}
	return part1, part2
}

@(private = "file")
score_pattern :: proc(pattern: []string, rows, cols: int) -> (smudge: int, no_smudge: int) {
	for c in 1 ..< cols {
		faults: int
		for r in 0 ..< rows {
			for offset in 0 ..< min(c, cols - c) {
				if pattern[r][c + offset] != pattern[r][c - offset - 1] do faults += 1
				if faults > 1 do break
			}
			if faults > 1 do break
		}
		if faults == 0 {
			smudge = c
		} else if faults == 1 {
			no_smudge = c
		}
		if smudge != 0 && no_smudge != 0 do return
	}
	for r in 1 ..< rows {
		faults: int
		for c in 0 ..< cols {
			for offset in 0 ..< min(r, rows - r) {
				if pattern[r + offset][c] != pattern[r - offset - 1][c] do faults += 1
				if faults > 1 do break
			}
		}
		if faults == 0 {
			smudge = 100 * r
		} else if faults == 1 {
			no_smudge = 100 * r
		}
		if smudge != 0 && no_smudge != 0 do return
	}
	return
}


@(private = "file")
test_input :: `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
`

@(test)
test_example_d13_p1 :: proc(t: ^testing.T) {
	part1, _ := day13(test_input)
	part1_expected := int(405)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d13_p2 :: proc(t: ^testing.T) {
	_, part2 := day13(test_input)
	part2_expected := int(400)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day13 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day13 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day13(string(options.input))
	}
	options.count = options.rounds
	return nil
}
