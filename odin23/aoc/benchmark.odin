package aoc

import "core:time"

bench_proc :: #type proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error

get_benchmarks :: proc(all_bench_procs: [NDAYS][2]bench_proc) -> (times: [NDAYS]f64, total: f64) {
	for bench_procs, day in all_bench_procs {
		options := &time.Benchmark_Options {
			rounds = 100,
			setup = bench_procs[0],
			bench = bench_procs[1],
			teardown = teardown,
		}
		time.benchmark(options)
		microseconds := time.duration_microseconds(options.duration) / f64(options.count)
		times[day] = microseconds
		total += microseconds
	}
	return times, total
}

teardown :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	delete(options.input)
	return nil
}
