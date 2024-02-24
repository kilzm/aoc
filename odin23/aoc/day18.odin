package aoc

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 18

@(private = "file")
Move :: struct {
	dir: u8,
	amt: int,
}

day18 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	moves_a, moves_b := parse(input)
	defer {
		delete(moves_a)
		delete(moves_b)
	}
	part1 = calculate_area(&moves_a)
	part2 = calculate_area(&moves_b)
	return part1, part2
}

@(private = "file")
parse :: #force_inline proc(input: string) -> (moves_a, moves_b: [dynamic]Move) {
	moves_b, moves_a = make([dynamic]Move, 0, 500), make([dynamic]Move, 0, 500)
	it := input
	for line in strings.split_lines_iterator(&it) {
		space := 3 + strings.index_byte(line[3:], ' ')
		append(&moves_a, Move{line[0], read_int(line[2:space])})
		append(&moves_b, Move{line[space + 8], read_int(line[space + 3:space + 8], 16)})
	}
	return
}

@(private = "file")
calculate_area :: proc(moves: ^[dynamic]Move) -> int {
	prev, pos: [2]int
	area, perim: int

	for move in moves {
		prev = pos
		switch move.dir {
		case 'D', '1':
			pos += {move.amt, 0}
		case 'U', '3':
			pos -= {move.amt, 0}
		case 'R', '0':
			pos += {0, move.amt}
		case 'L', '2':
			pos -= {0, move.amt}
		}
		area += prev.y * pos.x - prev.x * pos.y
		perim += move.amt
	}
	return area / 2 + perim / 2 + 1
}

@(private = "file")
test_input :: `R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)`

@(test)
test_example_d18_p1 :: proc(t: ^testing.T) {
	part1, _ := day18(test_input)
	part1_expected := int(62)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d18_p2 :: proc(t: ^testing.T) {
	_, part2 := day18(test_input)
	part2_expected := int(952408144115)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day18 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day18 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day18(string(options.input))
	}
	options.count = options.rounds
	return nil
}
