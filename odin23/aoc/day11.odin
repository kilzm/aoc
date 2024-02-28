//+private file
package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 11

@(private)
day11 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	galaxies: [dynamic][2]int
	grid := strings.split_lines(input)
	R, C := len(grid) - 1, len(grid[0])
	grid = grid[:R]
	gcols := make([]bool, C)
	erows, ecols := make([]int, R), make([]int, C)
	defer {
		delete(galaxies)
		delete(grid)
		delete(gcols)
		delete(erows)
		delete(ecols)
	}
	nerows: int
	for row, r in grid {
		grow: bool
		for point, c in row {
			if point == '#' {
				grow = true
				gcols[c] = true
				append(&galaxies, [2]int{r, c})
			}
		}
		if !grow do nerows += 1
		erows[r] = nerows
	}

	necols: int
	for c, i in gcols {
		if !c do necols += 1
		ecols[i] = necols
	}

	part1 = calculate(2, galaxies[:], erows, ecols)
	part2 = calculate(1_000_000, galaxies[:], erows, ecols)

	return part1, part2
}

calculate :: proc(factor: int, galaxies: [][2]int, erows, ecols: []int) -> (result: int) {
	galaxies_exp := make([][2]int, len(galaxies))
	defer delete(galaxies_exp)
	for galaxy, i in galaxies {
		r, c := galaxy.x, galaxy.y
		offset: [2]int = {(factor - 1) * erows[r], (factor - 1) * ecols[c]}
		galaxies_exp[i] = galaxy + offset
	}
	for g1, i in galaxies_exp {
		for g2 in galaxies_exp[i + 1:] {
			result += abs(g1.x - g2.x) + abs(g1.y - g2.y)
		}
	}

	return
}

test_input :: `...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
`

@(test, private)
test_example_d11_p1 :: proc(t: ^testing.T) {
	part1, _ := day11(test_input)
	part1_expected := int(374)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test, private)
test_example_d11_p2 :: proc(t: ^testing.T) {
	_, part2 := day11(test_input)
	part2_expected := int(82000210)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_day11 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day11 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day11(string(options.input))
	}
	options.count = options.rounds
	return nil
}
