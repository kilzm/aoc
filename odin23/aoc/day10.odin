//+private file
package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 10

UP :: [2]int{-1, 0}
RIGHT :: [2]int{0, 1}
DOWN :: [2]int{1, 0}
LEFT :: [2]int{0, -1}
offsets :: [4][2]int{UP, RIGHT, DOWN, LEFT}

@(private)
day10 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	lines := strings.split_lines(input)
	lines = lines[:len(lines) - 1]
	R, C := len(lines), len(lines[0])
	grid := make([]u8, R * C)
	lgrid := make([]u8, R * C)
	for line, i in lines do copy(grid[i * C:(i + 1) * C], line)
	defer {
		delete(lines)
		delete(grid)
		delete(lgrid)
	}

	pos: [2]int
	outer: for r in 0 ..< R {
		for c in 0 ..< C {
			if grid[C * r + c] == 'S' {
				pos = [2]int{r, c}
				break outer
			}
		}
	}

	dir := find_start_dir(grid, pos, R, C)

	minr, maxr, minc, maxc := pos.x, pos.x, pos.y, pos.y
	for {
		index := pos.x * C + pos.y
		lgrid[index] = grid[index]
		pos += dir
		if pos.x < minr {
			minr = pos.x
		} else if pos.x > maxr {
			maxr = pos.x
		}
		if pos.y < minc {
			minc = pos.y
		} else if pos.y > maxc {
			maxc = pos.y
		}
		gi := C * pos.x + pos.y
		tile := grid[gi]
		part1 += 1
		dir = walk(dir, tile)
		if tile == 'S' do break
	}

	part1 /= 2

	for r in minr ..= maxr {
		inside: bool
		for c in minc ..= maxc {
			switch lgrid[r * C + c] {
			case '|', 'F', '7':
				inside = !inside
			case 0:
				if inside {
					part2 += 1
				}
			}
		}
	}

	return part1, part2
}

find_start_dir :: #force_inline proc(grid: []u8, pos: [2]int, R, C: int) -> (dir: [2]int) {
	connected: u8
	reachable := [4][]u8{{'|', '7', 'F'}, {'-', '7', 'J'}, {'|', 'J', 'L'}, {'-', 'L', 'F'}}
	for offset, i in offsets {
		gi := C * (pos.x + offset.x) + pos.y + offset.y
		if gi < 0 || gi >= R * C do continue
		if slice.contains(reachable[i], grid[gi]) {
			connected |= 1 << u8(i)
		}
	}
	switch connected {
	case 0b1010:
		return RIGHT
	case 0b0101:
		return DOWN
	case 0b1100:
		return DOWN
	case 0b0110:
		return DOWN
	case 0b0011:
		return RIGHT
	case:
		return LEFT
	}
}

walk :: #force_inline proc(dir: [2]int, tile: u8) -> [2]int {
	switch tile {
	case 'F':
		return dir.x == -1 ? RIGHT : DOWN
	case '7':
		return dir.x == -1 ? LEFT : DOWN
	case 'L':
		return dir.x == 1 ? RIGHT : UP
	case 'J':
		return dir.x == 1 ? LEFT : UP
	case:
		return dir
	}
}

test_input_p1 :: `7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
`

@(test, private)
test_example_d10_p1 :: proc(t: ^testing.T) {
	part1, _ := day10(test_input_p1)
	part1_expected := int(8)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

test_input_p2 :: `FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
`

@(private, test)
test_example_d10_p2 :: proc(t: ^testing.T) {
	_, part2 := day10(test_input_p2)
	part2_expected := int(10)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_day10 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day10 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day10(string(options.input))
	}
	options.count = options.rounds
	return nil
}
