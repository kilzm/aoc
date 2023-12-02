package aoc

import "core:fmt"
import "core:mem"
import "core:mem/virtual"
import "core:os"
import "core:strings"
import "core:time"

day_proc :: proc(_: string) -> (result_t, result_t)
result_t :: union {
	int,
	u64,
	string,
}

run :: proc(day: int, procedure: day_proc, iter: int = 1) -> f64 {
	home := os.get_env("HOME")
	defer delete(home)

	filename_buf: strings.Builder
	filename := fmt.sbprintf(&filename_buf, "%s/.aoc_data/2023/day%i.in", home, day)
	defer delete(filename)

	content, ok := os.read_entire_file(filename)
	if !ok {
		fmt.println("Could not read file: ", filename)
		return 0
	};defer delete(content)

	acc: f64 = 0
	part1, part2: result_t
	for i in 0 ..< iter {
		stopwatch: time.Stopwatch

		time.stopwatch_start(&stopwatch)
		part1, part2 = procedure(string(content))
		time.stopwatch_stop(&stopwatch)

		acc += time.duration_milliseconds(stopwatch._accumulation)
	}

	average_time := acc / f64(iter)

	fmt.printf("day%02i | %fms\n", day, average_time)
	fmt.printf("    part 1: %v\n", part1)
	fmt.printf("    part 2: %v\n", part2)
	return average_time
}

main :: proc() {
	days := [?]day_proc{day01, day02}

	iter := 1
	args := os.args;defer delete(args)
	for i in 0 ..< len(args) {
		if strings.compare(os.args[i], "--bench") == 0 {
			iter = 100
		}
	}

	total_time: f64
	for procedure, day in days do total_time += run(day + 1, procedure, iter)

	fmt.printf("\ntotal | %fms\n", total_time)
}
