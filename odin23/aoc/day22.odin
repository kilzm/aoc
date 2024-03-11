//+private file
package aoc

import "base:intrinsics"
import "core:fmt"
import "core:slice"
import "core:sort"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 22

Brick :: struct {
	x1, y1, z1: int,
	x2, y2, z2: int,
}

@(private)
day22 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	bricks := parse(input)
	sort.quick_sort_proc(bricks, proc(a, b: Brick) -> int {return a.z1 - b.z1})

	required := make([]bool, len(bricks))

	Node :: struct {
		parent: int,
		depth:  int,
	}

	dominator := make([]Node, len(bricks))

	defer {
		delete(bricks)
		delete(required)
		delete(dominator)
	}

	S :: 10 * 10
	heights: [S]int
	hindices := [S]int {
		0 ..< S = -1,
	}

	for falling, i in bricks {
		using falling
		s := y1 * 10 + x1
		e := y2 * 10 + x2
		maxh: int
		mv := 10 if y2 > y1 else 1
		for j := s; j <= e; j += mv {
			maxh = max(heights[j], maxh)
		}

		prev, supporting := -1, 0
		node: Node
		for j := s; j <= e; j += mv {
			if heights[j] == maxh {
				hindex := hindices[j]
				if hindex != prev {
					prev = hindex
					supporting += 1

					if supporting == 1 {
						node = dominator[prev]
					} else {
						dom := dominator[prev]
						for node.depth > dom.depth {
							node = dominator[node.parent]
						}
						for dom.depth > node.depth {
							dom = dominator[dom.parent]
						}
						for node.parent != dom.parent {
							node, dom = dominator[node.parent], dominator[dom.parent]
						}
					}
				}
			}

			heights[j] = maxh + z2 - z1 + 1
			hindices[j] = i
		}

		if supporting == 1 {
			required[prev] = true
			node = Node{prev, dominator[prev].depth + 1}
		}

		dominator[i] = node
	}

	part1 = slice.count(required, false)
	part2 = slice.reduce(dominator, 0, proc(acc: int, n: Node) -> int {return acc + n.depth})

	return part1, part2
}

parse :: #force_inline proc(input: string) -> []Brick {
	bricks := make([dynamic]Brick)
	it := input
	for line in strings.split_lines_iterator(&it) {
		line, index, brick := line, 0, [6]int{}
		for num in strings.split_multi_iterate(&line, []string{",", "~"}) {
			brick[index] = read_int(num)
			index += 1
		}
		append(&bricks, transmute(Brick)brick)
	}
	return bricks[:]
}

test_input :: `1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9`

@(test, private)
test_example_d22_p1 :: proc(t: ^testing.T) {
	part1, _ := day22(test_input)
	part1_expected := int(5)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test, private)
test_example_d22_p2 :: proc(t: ^testing.T) {
	_, part2 := day22(test_input)
	part2_expected := int(7)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_day22 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day22 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day22(string(options.input))
	}
	options.count = options.rounds
	return nil
}
