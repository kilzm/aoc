//+private file
package aoc

import "core:container/queue"
import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 21

SIZE :: 131
START :: [2]int{65, 65}
CORNERS :: [][2]int{{0, 0}, {0, 130}, {130, 0}, {130, 130}}
DIRS :: [][2]int{{-1, 0}, {0, 1}, {1, 0}, {0, -1}}

@(private)
day21 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int

	grid := parse(input)
	defer delete(grid)

	even, odd := bfs(grid[:], 130, START)
	part1 = even.x

	ceven, _ := bfs(grid[:], 64, ..CORNERS)

	N :: 202300
	part2 =
		N * N * (even.x + even.y) +
		(N + 1) * (N + 1) * (odd.x + odd.y) +
		N * ceven.x -
		(N + 1) * odd.y

	return part1, part2
}

parse :: #force_inline proc(input: string) -> (grid: [dynamic]u8) {
	grid = make([dynamic]u8)
	it := input
	for line in strings.split_lines_iterator(&it) do append(&grid, line[:])
	return
}

bfs :: proc(grid_: []u8, $limit: int, starts: ..[2]int) -> (even: [2]int, odd: [2]int) {
	grid := make([]u8, SIZE * SIZE)
	defer delete(grid)
	copy(grid, grid_)

	Node :: struct {
		pos:  [2]int,
		cost: int,
	}

	q: queue.Queue(Node)
	queue.init(&q, 280)
	defer queue.destroy(&q)

	for start in starts {
		queue.push_back(&q, Node{start, 0})
		grid[start.x * SIZE + start.y] = '#'
	}

	for queue.len(q) > 0 {
		using node := queue.pop_front(&q)
		switch cost % 2 {
		case 0:
			even += {1, 0} if cost <= 64 else {0, 1}
		case 1:
			odd += {1, 0} if abs(pos.x - START.x) + abs(pos.y - START.y) <= 65 else {0, 1}
		}

		if cost < limit {
			for &dir in DIRS {
				npos := pos + dir
				index := npos.x * SIZE + npos.y
				if 0 <= index && index < SIZE * SIZE && grid[index] != '#' {
					queue.push_back(&q, Node{npos, cost + 1})
					grid[index] = '#'
				}
			}
		}
	}
	return
}

@(private)
setup_day21 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day21 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day21(string(options.input))
	}
	options.count = options.rounds
	return nil
}
