//+private file
package aoc

import "core:intrinsics"
import "core:slice"
import "core:strings"
import "core:time"

DAY :: 20

@(private)
day20 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: u64
	limits := parse(input)
	part1 = count_pulses(limits)
	part2 = slice.reduce(limits[:], u64(1), proc(a, b: u64) -> u64 {return a * b})

	return part1, part2
}

parse :: proc(input: string) -> (limits: [4]u64) {
	connections := make(map[string][]string)
	conjunctions := make(map[string]bool)
	defer {
		for _, c in connections do delete(c)
		delete(connections)
		delete(conjunctions)
	}

	it := input
	for line in strings.split_lines_iterator(&it) {
		space := strings.index_rune(line, ' ')
		connected := strings.split(line[space + 4:], ", ")
		if line[0] == 'b' {
			connections["broadcaster"] = connected
			conjunctions["broadcaster"] = false
		} else {
			name := line[1:space]
			connections[name] = connected
			conjunctions[name] = line[0] != '&'
		}
	}

	Entry :: struct {
		name:     string,
		val, bit: u64,
	}

	li: int
	q := make([dynamic]Entry)
	defer delete(q)
	for name in connections["broadcaster"] {
		append(&q, Entry{name, 0, 1})
	}

	for len(q) > 0 {
		using entry := pop(&q)
		connected := connections[name]
		ci := -1
		for c, i in connected {
			if conjunctions[c] {
				ci = i
				break
			}
		}
		if ci != -1 {
			if len(connected) == 2 {
				val |= bit
			}
			append(&q, Entry{connected[ci], val, bit << 1})
		} else {
			limits[li] = val | bit
			li += 1
		}
	}
	return
}

count_pulses :: #force_inline proc(limits: [4]u64) -> u64 {
	low := u64(5000)
	high := u64(4000)

	resets: [4]u64
	#unroll for i in 0 ..< 4 do resets[i] = 12 - intrinsics.count_ones(limits[i]) + 1

	for n in u64(0) ..< u64(1000) {
		activating: u64 = ~n & (n + 1)
		deactivating: u64 = n & ~(n + 1)
		low += 4 * intrinsics.count_ones(deactivating)

		#unroll for i in 0 ..< 4 {
			l, r := limits[i], resets[i]
			f: u64
			f = intrinsics.count_ones(activating & l)
			high += f * (r + 3)
			low += f

			f = intrinsics.count_ones(deactivating & l)
			high += f * (r + 2)
			low += 2 * f
		}
	}
	return low * high
}

@(private)
setup_day20 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day20 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day20(string(options.input))
	}
	options.count = options.rounds
	return nil
}
