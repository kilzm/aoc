package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 10

@(private = "file")
Offset :: [2]int

@(private = "file")
UP :: Offset{-1, 0}
@(private = "file")
RIGHT :: Offset{0, 1}
@(private = "file")
DOWN :: Offset{1, 0}
@(private = "file")
LEFT :: Offset{0, -1}
@(private = "file")
offsets :: [4]Offset{UP, RIGHT, DOWN, LEFT}

day10 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	it := input[:]
	lines := strings.split_lines(input)
	lines = lines[:len(lines) - 1]
	R, C := len(lines), len(lines[0])
	R3, C3 := R * 3, C * 3
	grid := make([]u8, R * C)
	grid3 := make([]u8, R3 * C3)
	for line, i in lines do copy_from_string(grid[i * C:(i + 1) * C], line)
	defer {
		delete(lines)
		delete(grid)
		delete(grid3)
	}

	found_start: bool
	pos: Offset
	for r in 0 ..< R {
		for c in 0 ..< C {
			if grid[C * r + c] == 'S' {
				pos = Offset{r, c}
				found_start = true
				break
			}
		}
		if found_start do break
	}

	start_tile, dir := find_start_tile_and_dir(grid, pos, R, C)

	for {
		pos += dir
		r, c := pos[0], pos[1]
		gi := C * r + c
		tile := grid[gi]
		part1 += 1
		dir = walk(dir, tile)
		grid[gi] = '#'
		if tile == 'S' do break
		fill_grid3(grid3, C3, r, c, tile)
	}
	part1 /= 2

	fill_grid3(grid3, C3, pos[0], pos[1], start_tile)

	part2 = R * C
	outside := make([]bool, R * C)
	defer delete(outside)

	stack := make([dynamic]Offset)
	defer delete(stack)
	append(&stack, Offset{0, 0})
	for len(stack) != 0 {
		pos := pop(&stack)
		r, c := pos[0], pos[1]
		gi := C3 * r + c
		if grid3[gi] == '#' || grid3[gi] == 'O' do continue
		or, oc := r / 3, c / 3
		outside[C * (r / 3) + (c / 3)] = true
		grid3[gi] = 'O'
		for offset in offsets {
			rr, cc := r + offset[0], c + offset[1]
			if 0 <= rr && rr < R3 && 0 <= cc && cc < C3 do append(&stack, Offset{rr, cc})
		}
	}
	part2 -= slice.count(outside, true)
	return part1, part2
}

@(private = "file")
find_start_tile_and_dir :: proc(grid: []u8, pos: Offset, R, C: int) -> (tile: u8, dir: Offset) {
	r, c := pos[0], pos[1]
	connected: u8
	reachable := [4][]u8{{'|', '7', 'F'}, {'-', '7', 'J'}, {'|', 'J', 'L'}, {'-', 'L', 'F'}}
	for offset, i in offsets {
		gi := C * (r + offset[0]) + c + offset[1]
		if gi < 0 || gi >= R * C do continue
		if slice.contains(reachable[i], grid[gi]) {
			connected |= 1 << u8(i)
		}
	}
	switch connected {
	case 0b1010:
		return '-', RIGHT
	case 0b0101:
		return '|', DOWN
	case 0b1100:
		return '7', DOWN
	case 0b0110:
		return 'F', DOWN
	case 0b0011:
		return 'L', RIGHT
	case 0b1001:
		return 'J', LEFT
	}
	return
}

@(private = "file")
walk :: proc(dir: Offset, tile: u8) -> Offset {
	switch tile {
	case 'F':
		return dir[0] == -1 ? RIGHT : DOWN
	case '7':
		return dir[0] == -1 ? LEFT : DOWN
	case 'L':
		return dir[0] == 1 ? RIGHT : UP
	case 'J':
		return dir[0] == 1 ? LEFT : UP
	case:
		return dir
	}
}

@(private = "file")
fill_grid3 :: proc(grid3: []u8, C, r, c: int, tile: u8) {
	E, P :: 0, '#'
	I := [3][]u8{{E, P, E}, {E, P, E}, {E, P, E}}
	D := [3][]u8{{E, E, E}, {P, P, P}, {E, E, E}}
	L := [3][]u8{{E, P, E}, {E, P, P}, {E, E, E}}
	J := [3][]u8{{E, P, E}, {P, P, E}, {E, E, E}}
	F := [3][]u8{{E, E, E}, {E, P, P}, {E, P, E}}
	S := [3][]u8{{E, E, E}, {P, P, E}, {E, P, E}}
	tile3: [3][]u8
	switch tile {
	case '|':
		tile3 = I
	case '-':
		tile3 = D
	case 'L':
		tile3 = L
	case 'J':
		tile3 = J
	case 'F':
		tile3 = F
	case '7':
		tile3 = S
	}
	start := C * (r * 3) + (3 * c)
	for i in 0 ..< 3 {
		copy(grid3[start + i * C:], tile3[i])
	}
}

@(private = "file")
test_input_p1 :: `7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
`

@(test)
test_example_d10_p1 :: proc(t: ^testing.T) {
	part1, _ := day10(test_input_p1)
	part1_expected := int(8)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(private = "file")
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

@(test)
test_example_d10_p2 :: proc(t: ^testing.T) {
	_, part2 := day10(test_input_p2)
	part2_expected := int(0)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day10 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

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
