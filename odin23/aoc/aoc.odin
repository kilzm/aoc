package aoc

import "core:fmt"
import "core:os"
import "core:strings"

result_t :: union {
	int,
	u64,
	i64,
	string,
}

NDAYS :: 18

day_proc :: #type proc(_: string) -> (result_t, result_t)

main :: proc() {
	days := [NDAYS]day_proc {
		day01,
		day02,
		day03,
		day04,
		day05,
		day06,
		day07,
		day08,
		day09,
		day10,
		day11,
		day12,
		day13,
		day14,
		day15,
		day16,
		day17,
        day18,
	}

	all_bench_procs := [NDAYS]([2]bench_proc) {
		{setup_day01, bench_day01},
		{setup_day02, bench_day02},
		{setup_day03, bench_day03},
		{setup_day04, bench_day04},
		{setup_day05, bench_day05},
		{setup_day06, bench_day06},
		{setup_day07, bench_day07},
		{setup_day08, bench_day08},
		{setup_day09, bench_day09},
		{setup_day10, bench_day10},
		{setup_day11, bench_day11},
		{setup_day12, bench_day12},
		{setup_day13, bench_day13},
		{setup_day14, bench_day14},
		{setup_day15, bench_day15},
		{setup_day16, bench_day16},
		{setup_day17, bench_day17},
		{setup_day18, bench_day18},
	}

	bench := parse_args()

	if bench {
		bench_times, total := get_benchmarks(all_bench_procs)
		for procedure, day in days do run(day + 1, procedure, bench_times[day])
		fmt.printf("total | %fms\n", total)
	} else {
		for procedure, day in days do run(day + 1, procedure)
	}
}

parse_args :: proc() -> (bench: bool) {
	args := os.args
	defer delete(args)
	for i in 0 ..< len(args) {
		if strings.compare(os.args[i], "--bench") == 0 {
			bench = true
		}
	}
	return bench
}

get_input :: proc(day: int) -> []u8 {
	home := os.get_env("HOME")
	defer delete(home)
	filename_buf: strings.Builder
	filename := fmt.sbprintf(&filename_buf, "%s/.aoc_data/2023/day%i.in", home, day)
	defer delete(filename)
	input, ok := os.read_entire_file(filename)
	if !ok {
		fmt.println("Could not read file: ", filename)
		return transmute([]u8)string("")
	}
	return input
}

run :: proc(day: int, procedure: day_proc, bench_time: f64 = -1) {
	input := get_input(day)
	defer delete(input)

	part1, part2 := procedure(string(input))

	if (bench_time == -1) {
		fmt.printf("day%02i\n", day)
	} else {
		fmt.printf("day%02i | %fms\n", day, bench_time)
	}
	fmt.printf("    part 1: %v\n", part1)
	fmt.printf("    part 2: %v\n", part2)
}
