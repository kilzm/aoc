package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 17

day17 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: u64
	lines := strings.split_lines(input[:len(input) - 1])
	rows, cols := u32(len(lines)), u32(len(lines[0]))
	grid := make([]u32, rows * cols)
	for line, r in lines {
		for num, c in line {
			grid[u32(r) * cols + u32(c)] = u32(num) - '0'
		}
	}

	defer {
		delete(lines)
		delete(grid)
	}

	part1 = u64(astar(&grid, rows, cols, 1, 3))
	part2 = u64(astar(&grid, rows, cols, 4, 10))

	return part1, part2
}


@(private = "file")
astar :: #force_inline proc(heat: ^[]u32, rows, cols, mind, maxd: u32) -> u32 {
	N :: 128
	Orientation :: enum {
		V,
		H,
	}

	Node :: struct {
		pos:         [2]u32,
		orientation: Orientation,
	}

	bq: [N][dynamic]Node
	for _, i in bq {
		bq[i] = make([dynamic]Node, N)
	}
	cost := make([][2]u32, len(heat))

	defer {
		for i in 0 ..< len(bq) do delete(bq[i])
		delete(cost)
	}

	append(&bq[0], Node{{0, 0}, .V})
	append(&bq[0], Node{{0, 0}, .H})

	heuristic :: #force_inline proc(pos: [2]u32, heat, rows, cols: u32) -> u32 {
		return (heat + cols + rows - (pos.x + pos.y)) % N
	}

	prio: u32 = 0
	for {
		qptr := &bq[prio % N]
		for len(qptr^) > 0 {
			using cur := pop(qptr)
			index := pos.x * cols + pos.y
			dist := cost[index][orientation]

			if pos == {rows - 1, cols - 1} {
				return dist
			}

			i, dh: u32
			switch orientation {
			case .V:
				// left
				i, dh = index, dist
				for d in 1 ..= maxd {
					if d > pos.y do break
					i -= 1
					dh += heat[i]
					c, npos := &cost[i][Orientation.H], pos - {0, d}
					if d >= mind && (dh < c^ || c^ == 0) {
						append(&bq[heuristic(npos, dh, rows, cols)], Node{npos, .H})
						c^ = dh
					}
				}

				// right
				i, dh = index, dist
				for d in 1 ..= maxd {
					if pos.y + d >= cols do break
					i += 1
					dh += heat[i]
					c, npos := &cost[i][Orientation.H], pos + {0, d}
					if d >= mind && (dh < c^ || c^ == 0) {
						append(&bq[heuristic(npos, dh, rows, cols)], Node{npos, .H})
						c^ = dh
					}
				}

			case .H:
				// up
				i, dh = index, dist
				for d in 1 ..= maxd {
					if d > pos.x do break
					i -= cols
					dh += heat[i]
					c, npos := &cost[i][Orientation.V], pos - {d, 0}
					if d >= mind && (dh < c^ || c^ == 0) {
						append(&bq[heuristic(npos, dh, rows, cols)], Node{npos, .V})
						c^ = dh
					}
				}

				// down
				i, dh = index, dist
				for d in 1 ..= maxd {
					if pos.x + d >= rows do break
					i += cols
					dh += heat[i]
					c, npos := &cost[i][Orientation.V], pos + {d, 0}
					if d >= mind && (dh < c^ || c^ == 0) {
						append(&bq[heuristic(npos, dh, rows, cols)], Node{npos, .V})
						c^ = dh
					}
				}
			}
		}
		prio += 1
	}

	return 0
}

@(private = "file")
test_input :: `2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
`

@(test)
test_example_d17_p1 :: proc(t: ^testing.T) {
	part1, _ := day17(test_input)
	part1_expected := u64(102)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d17_p2 :: proc(t: ^testing.T) {
	_, part2 := day17(test_input)
	part2_expected := u64(94)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day17 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day17 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day17(string(options.input))
	}
	options.count = options.rounds
	return nil
}
