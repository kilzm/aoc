//+private file
package aoc

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 6

Race :: struct {
	time, distance: i64,
}

@(private)
day06 :: proc(input: string) -> (result_t, result_t) {
	part1: i64 = 1
	part2: i64
	races, race_joined := parse_input(input)
	defer delete(races)
	for race in races {
		lower, upper := calculate_winning_range(race)
		part1 *= upper - lower + 1
	}
	lower, upper := calculate_winning_range(race_joined)
	part2 = upper - lower + 1
	return part1, part2
}

parse_input :: proc(input: string) -> ([]Race, Race) {
	races: [dynamic]Race
	lines := strings.split_lines(input)
	times, distances := strings.fields(lines[0][10:]), strings.fields(lines[1][10:])
	time_joined, distance_joined := strings.join(times[:], ""), strings.join(distances[:], "")
	defer {
		delete(lines)
		delete(times)
		delete(distances)
		delete(time_joined)
		delete(distance_joined)
	}
	for i in 0 ..< len(times) {
		time, _ := strconv.parse_i64(times[i])
		distance, _ := strconv.parse_i64(distances[i])
		append(&races, Race{time, distance})
	}
	return races[:], Race{read_i64(time_joined), read_i64(distance_joined)}
}

calculate_winning_range :: proc(race: Race) -> (lower, upper: i64) {
	fb, fc := f64(race.time), f64(-race.distance) - 0.0000000001
	discriminant := math.sqrt_f64(fb * fb + 4 * fc)
	lower = i64(math.ceil((-fb + discriminant) / -2))
	upper = i64(math.floor((-fb - discriminant) / -2))
	return
}

test_input :: `Time:      7  15   30
Distance:  9  40  200
`

@(test, private)
test_example_d06_p1 :: proc(t: ^testing.T) {
	part1, _ := day06(test_input)
	part1_expected := i64(288)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test, private)
test_example_d06_p2 :: proc(t: ^testing.T) {
	_, part2 := day06(test_input)
	part2_expected := i64(71503)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_day06 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day06 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day06(string(options.input))
	}
	options.count = options.rounds
	return nil
}
