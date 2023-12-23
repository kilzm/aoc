package aoc

import "core:fmt"
import "core:hash/xxhash"
import "core:slice"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 14

@(private = "file")
Direction :: enum {
	NORTH,
	SOUTH,
	EAST,
	WEST,
}

@(private = "file")
hash :: distinct u128

day14 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	lines := strings.split_lines(input[:len(input) - 1])
	defer delete(lines)
	rows, cols := len(lines), len(lines[0])
	rocks := make([]u8, rows * cols)
	for line, i in lines {
		copy(rocks[i * cols:(i + 1) * cols], transmute([]u8)line)
	}
	defer delete(rocks)

	total_rocks: int
	for c in input do if c == 'O' do total_rocks += 1

	tilt(rocks, rows, cols, .NORTH)
	part1 = get_load(rocks, rows, cols)

	seen_positions := make([dynamic]hash)
	defer delete(seen_positions)

	cycles, cycle_interval: int
	for {
		new_position := cycle(rocks, rows, cols, total_rocks)
		if pcycle, found := slice.linear_search(seen_positions[:], new_position); found {
			cycle_interval = cycles - pcycle
			break
		}
		append(&seen_positions, new_position)
		cycles += 1
	}
	remaining := (1_000_000_000 - cycles) %% cycle_interval
	for _ in 0 ..< remaining - 1 {
		cycle(rocks, rows, cols, total_rocks)
	}
	part2 = get_load(rocks, rows, cols)
	return part1, part2
}

@(private = "file")
cycle :: proc(rocks: []u8, rows, cols, nrocks: int) -> hash {
	tilt(rocks, rows, cols, .NORTH)
	tilt(rocks, rows, cols, .WEST)
	tilt(rocks, rows, cols, .SOUTH)
	tilt(rocks, rows, cols, .EAST)
	return transmute(hash)xxhash.XXH3_128_default(transmute([]u8)rocks)
}

@(private = "file")
tilt :: proc(rocks: []u8, rows, cols: int, dir: Direction) {
	up, down: int
	switch dir {
	case .NORTH:
		for c in 0 ..< cols {
			stop, count := -1, 0
			for r := 0; r < rows; r += 1 {
				if rocks[r * cols + c] == 'O' {
					rocks[r * cols + c] = '.'
					count += 1
				}
				if rocks[r * cols + c] == '#' || r == rows - 1 {
					for rr in stop + 1 ..< stop + count + 1 do rocks[rr * cols + c] = 'O'
					count = 0
					stop = r
				}
			}
		}
	case .SOUTH:
		for c in 0 ..< cols {
			stop, count := rows, 0
			for r := rows - 1; r >= 0; r -= 1 {
				if rocks[r * cols + c] == 'O' {
					rocks[r * cols + c] = '.'
					count += 1
				}
				if rocks[r * cols + c] == '#' || r == 0 {
					for rr := stop - 1; rr > stop - 1 - count; rr -= 1 do rocks[rr * cols + c] = 'O'
					count = 0
					stop = r
				}
			}
		}
	case .WEST:
		for r in 0 ..< rows {
			stop, count := -1, 0
			for c := 0; c < cols; c += 1 {
				if rocks[r * cols + c] == 'O' {
					rocks[r * cols + c] = '.'
					count += 1
				}
				if rocks[r * cols + c] == '#' || c == cols - 1 {
					for cc in stop + 1 ..< stop + count + 1 do rocks[r * cols + cc] = 'O'
					count = 0
					stop = c
				}

			}
		}
	case .EAST:
		for r in 0 ..< rows {
			stop, count := cols, 0
			for c := cols - 1; c >= 0; c -= 1 {
				if rocks[r * cols + c] == 'O' {
					rocks[r * cols + c] = '.'
					count += 1
				}
				if rocks[r * cols + c] == '#' || c == 0 {
					for cc := stop - 1; cc > stop - 1 - count; cc -= 1 do rocks[r * cols + cc] = 'O'
					count = 0
					stop = c
				}

			}
		}
	}
}

@(private = "file")
get_load :: proc(rocks: []u8, rows, cols: int) -> (load: int) {
	for r in 0 ..< rows {
		per_rock := rows - r
		for rock in rocks[r * cols:(r + 1) * cols] do if rock == 'O' do load += per_rock
	}
	return
}

@(private = "file")
test_input :: `O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
`

@(test)
test_example_d14_p1 :: proc(t: ^testing.T) {
	part1, _ := day14(test_input)
	part1_expected := int(136)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d14_p2 :: proc(t: ^testing.T) {
	_, part2 := day14(test_input)
	part2_expected := int(64)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day14 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day14 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day14(string(options.input))
	}
	options.count = options.rounds
	return nil
}
