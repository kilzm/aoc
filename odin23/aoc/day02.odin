//+private file
package aoc

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 2

@(private)
day02 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	it := input[:]
	linenr: int
	for line in strings.split_lines_iterator(&it) {
		game := line[strings.index(line, ":") + 2:]
		if check_game(game) do part1 += linenr + 1
		part2 += get_power_for_game(game)
		linenr += 1
	}
	return part1, part2
}

check_game :: proc(game: string) -> bool {
	it := game[:]
	for sample in strings.split_iterator(&it, "; ") {
		sample_it := sample[:]
		for color_sample in strings.split_iterator(&sample_it, ", ") {
			a, _, c := strings.partition(color_sample, " ")
			amount := strconv.atoi(a)
			color := c[0]
			if (color == 'r' && amount > 12 ||
				   color == 'g' && amount > 13 ||
				   color == 'b' && amount > 14) {
				return false
			}
		}
	}
	return true
}

get_power_for_game :: proc(game: string) -> int {
	red, green, blue: int
	it := game[:]
	for sample in strings.split_iterator(&it, "; ") {
		sample_it := sample[:]
		for color_sample in strings.split_iterator(&sample_it, ", ") {
			space := strings.index(color_sample, " ")
			amount := strconv.atoi(color_sample[:space])
			color := color_sample[space + 1]
			switch color {
			case 'r':
				red = max(red, amount)
			case 'g':
				green = max(green, amount)
			case 'b':
				blue = max(blue, amount)
			}
		}
	}
	return red * green * blue
}

test_input :: `Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green`

@(test, private)
test_example_d02_p1 :: proc(t: ^testing.T) {
	part1, _ := day02(test_input)
	part1_expected := int(8)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test, private)
test_example_d02_p2 :: proc(t: ^testing.T) {

	_, part2 := day02(test_input)
	part2_expected := int(2286)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_day02 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day02 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day02(string(options.input))
	}
	options.count = options.rounds
	return nil
}
