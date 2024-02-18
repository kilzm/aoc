package aoc

import "core:fmt"
import "core:math/bits"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 16

@(private = "file")
Dir :: enum {
	NONE = -1,
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

@(private = "file")
Visits :: [110][4]u128

@(private = "file")
Edges :: [4]u128

@(private = "file")
Graph :: [110][110][4]Dest

@(private = "file")
Pos :: [2]int

@(private = "file")
Dest :: struct {
	pos1, pos2: Pos,
	dir1, dir2: Dir,
}

day16 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	graph, rows, cols := parse(input)
	edges: Edges
	part1 = get_energized(&graph, rows, cols, {0, 0}, Dir.EAST, &edges)
	part2 = part1
	for c in 0 ..< cols {
		mask: u128 = 1 << u32(c)
		if edges[Dir.NORTH] & mask == 0 {
			part2 = max(part2, get_energized(&graph, rows, cols, {0, c}, Dir.SOUTH, &edges))
		}
		if edges[Dir.SOUTH] & mask == 0 {
			part2 = max(part2, get_energized(&graph, rows, cols, {rows - 1, c}, Dir.NORTH, &edges))
		}
	}
	for r in 0 ..< rows {
		mask: u128 = 1 << u32(r)
		if edges[Dir.WEST] & mask == 0 {
			part2 = max(part2, get_energized(&graph, rows, cols, {r, 0}, Dir.EAST, &edges))
		}
		if edges[Dir.EAST] & mask == 0 {
			part2 = max(part2, get_energized(&graph, rows, cols, {r, cols - 1}, Dir.WEST, &edges))
		}
	}
	return part1, part2
}

@(private = "file")
get_energized :: proc(
	graph: ^Graph,
	rows, cols: int,
	start: Pos,
	dir: Dir,
	edges: ^Edges,
) -> (
	energized: int,
) {
	visits: Visits
	steps := make([dynamic]Dest)
	defer delete(steps)
	append(&steps, graph[start.x][start.y][dir])
	visits[start.x][dir] |= (1 << u32(start.y))
	for len(steps) != 0 {
		step := pop(&steps)
		update(&steps, graph, &visits, edges, step.pos1, step.dir1, rows, cols)
		if step.dir2 != .NONE do update(&steps, graph, &visits, edges, step.pos2, step.dir2, rows, cols)
	}
	for visit in visits {
		v := visit[0] | visit[1] | visit[2] | visit[3]
		energized += int(bits.count_ones(v))
	}
	return
}

@(private = "file")
update :: proc(
	steps: ^[dynamic]Dest,
	graph: ^Graph,
	visits: ^Visits,
	edges: ^Edges,
	pos: Pos,
	dir: Dir,
	rows, cols: int,
) {
	switch {
	case pos.x < 0:
		edges[Dir.NORTH] |= 1 << u32(pos.y)
	case pos.x >= rows:
		edges[Dir.SOUTH] |= 1 << u32(pos.y)
	case pos.y < 0:
		edges[Dir.WEST] |= 1 << u32(pos.x)
	case pos.y >= cols:
		edges[Dir.EAST] |= 1 << u32(pos.x)
	case:
		if visits[pos.x][dir] & (1 << u32(pos.y)) == 0 {
			visits[pos.x][dir] |= 1 << u32(pos.y)
			append(steps, graph[pos.x][pos.y][dir])
		}
	}
}

@(private = "file")
parse :: proc(input: string) -> (graph: Graph, rows, cols: int) {
	it := input[:]
	cols = strings.index_rune(input, '\n')
	r := 0
	for line in strings.split_lines_iterator(&it) {
		for symbol, c in line {
			gn := &graph[r][c][Dir.NORTH]
			ge := &graph[r][c][Dir.EAST]
			gs := &graph[r][c][Dir.SOUTH]
			gw := &graph[r][c][Dir.WEST]
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

@(private = "file")
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

@(test)
test_example_d16_p1 :: proc(t: ^testing.T) {
	part1, _ := day16(test_input)
	part1_expected := int(46)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d16_p2 :: proc(t: ^testing.T) {
	_, part2 := day16(test_input)
	part2_expected := int(51)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day16 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

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
