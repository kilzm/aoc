//+private file
package aoc

import "core:fmt"
import "core:math/bits"
import "core:strings"
import "core:sync"
import "core:testing"
import "core:thread"
import "core:time"

DAY :: 16

Dir :: enum {
	NONE = -1,
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

Graph :: [4][110]#soa[110]Dest

Dest :: struct {
	pos1, pos2: [2]int,
	dir1, dir2: Dir,
}

@(private)
day16 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	graph, rows, cols := parse(input)
	edges: [4]u128
	part1 = get_energized(&graph, rows, cols, {0, 0}, Dir.EAST, &edges)

	Todo :: struct {
		pos:  [2]int,
		from: Dir,
		opp:  Dir,
	}

	npoints := 2 * rows + 2 * cols
	points := make([][2]int, npoints)
	defer delete(points)

	index: int
	for r in 0 ..< rows {
		points[index] = {r, 0}
		points[index + 1] = {r, cols - 1}
		index += 2
	}
	for c in 0 ..< cols {
		points[index] = {0, c}
		points[index + 1] = {rows - 1, c}
		index += 2
	}

	ThreadData :: struct {
		result: ^int,
		rows:   int,
		cols:   int,
		points: [][2]int,
		graph:  ^Graph,
		edges:  ^[4]u128,
	}

	worker :: proc(using data: ^ThreadData, start, end: int) {
		for i in start ..< end {
			point := points[i]
			d1, d2: Dir
			mask: u128
			if point.x == 0 {
				mask = 1 << u32(point.y)
				d1, d2 = .NORTH, .SOUTH
			} else if point.x == rows - 1 {
				mask = 1 << u32(point.y)
				d1, d2 = .SOUTH, .NORTH
			} else if point.y == 0 {
				mask = 1 << u32(point.x)
				d1, d2 = .EAST, .WEST
			} else if point.y == cols - 1 {
				mask = 1 << u32(point.x)
				d1, d2 = .WEST, .EAST
			}
			if mask & edges[d1] == 0 {
				cur := get_energized(graph, rows, cols, point, d2, edges)
				result^ = max(cur, result^)
			}
		}
	}

	T :: 22
	threads: [T]^thread.Thread
	results: [T]int
	per_thread, start := npoints / T + 1, 0
	for i in 0 ..< T {
		end := min(start + per_thread, npoints)
		data := ThreadData{&results[i], rows, cols, points, &graph, &edges}
		threads[i] = thread.create_and_start_with_poly_data3(&data, start, end, worker)
		start = end
	}

	for i in 0 ..< T {
		thread.join(threads[i])
		thread.destroy(threads[i])
		part2 = max(part2, results[i])
	}

	return part1, part2
}

get_energized :: #force_inline proc(
	graph: ^Graph,
	rows, cols: int,
	start: [2]int,
	dir: Dir,
	edges: ^[4]u128,
) -> (
	energized: int,
) {
	visits: [110][4]u128
	steps := make([dynamic]Dest)
	defer delete(steps)
	append(&steps, graph[dir][start.x][start.y])

	visits[start.x][dir] |= 1 << u32(start.y)

	for len(steps) != 0 {
		step := pop(&steps)
		update(&steps, graph, &visits, edges, step.pos1, step.dir1, rows, cols)
		if step.dir2 != .NONE {
			update(&steps, graph, &visits, edges, step.pos2, step.dir2, rows, cols)
		}
	}

	for &visit in visits {
		v := visit.x | visit.y | visit.z | visit.w
		energized += int(bits.count_ones(v))
	}

	return
}

update :: #force_inline proc(
	steps: ^[dynamic]Dest,
	graph: ^Graph,
	visits: ^[110][4]u128,
	edges: ^[4]u128,
	pos: [2]int,
	dir: Dir,
	rows, cols: int,
) {
	switch {
	case pos.x < 0:
		sync.atomic_or(&edges[Dir.NORTH], 1 << u32(pos.y))
	case pos.x >= rows:
		sync.atomic_or(&edges[Dir.SOUTH], 1 << u32(pos.y))
	case pos.y < 0:
		sync.atomic_or(&edges[Dir.WEST], 1 << u32(pos.x))
	case pos.y >= cols:
		sync.atomic_or(&edges[Dir.EAST], 1 << u32(pos.x))
	case:
		if visits[pos.x][dir] & (1 << u32(pos.y)) == 0 {
			visits[pos.x][dir] |= 1 << u32(pos.y)
			append(steps, graph[dir][pos.x][pos.y])
		}
	}
}

parse :: #force_inline proc(input: string) -> (graph: Graph, rows, cols: int) {
	it := input[:]
	cols = strings.index_rune(input, '\n')
	r := 0
	for line in strings.split_lines_iterator(&it) {
		for symbol, c in line {
			gn := &graph[Dir.NORTH][r][c]
			ge := &graph[Dir.EAST][r][c]
			gs := &graph[Dir.SOUTH][r][c]
			gw := &graph[Dir.WEST][r][c]
			switch symbol {
			case '.':
				gn^ = Dest{{r - 1, c}, {}, .NORTH, .NONE}
				ge^ = Dest{{r, c + 1}, {}, .EAST, .NONE}
				gs^ = Dest{{r + 1, c}, {}, .SOUTH, .NONE}
				gw^ = Dest{{r, c - 1}, {}, .WEST, .NONE}
			case '/':
				gn^ = Dest{{r, c + 1}, {}, .EAST, .NONE}
				ge^ = Dest{{r - 1, c}, {}, .NORTH, .NONE}
				gs^ = Dest{{r, c - 1}, {}, .WEST, .NONE}
				gw^ = Dest{{r + 1, c}, {}, .SOUTH, .NONE}
			case '\\':
				gn^ = Dest{{r, c - 1}, {}, .WEST, .NONE}
				ge^ = Dest{{r + 1, c}, {}, .SOUTH, .NONE}
				gs^ = Dest{{r, c + 1}, {}, .EAST, .NONE}
				gw^ = Dest{{r - 1, c}, {}, .NORTH, .NONE}
			case '-':
				gn^ = Dest{{r, c - 1}, {r, c + 1}, .WEST, .EAST}
				ge^ = Dest{{r, c + 1}, {}, .EAST, .NONE}
				gs^ = Dest{{r, c - 1}, {r, c + 1}, .WEST, .EAST}
				gw^ = Dest{{r, c - 1}, {}, .WEST, .NONE}
			case '|':
				gn^ = Dest{{r - 1, c}, {}, .NORTH, .NONE}
				ge^ = Dest{{r - 1, c}, {r + 1, c}, .NORTH, .SOUTH}
				gs^ = Dest{{r + 1, c}, {}, .SOUTH, .NONE}
				gw^ = Dest{{r - 1, c}, {r + 1, c}, .NORTH, .SOUTH}
			}
		}
		r += 1
	}
	rows = r
	return
}

test_input :: `.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
`

@(test, private)
test_example_d16_p1 :: proc(t: ^testing.T) {
	part1, _ := day16(test_input)
	part1_expected := int(46)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test, private)
test_example_d16_p2 :: proc(t: ^testing.T) {
	_, part2 := day16(test_input)
	part2_expected := int(51)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_day16 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day16 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day16(string(options.input))
	}
	options.count = options.rounds
	return nil
}
