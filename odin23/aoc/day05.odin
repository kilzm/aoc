package aoc

import "core:fmt"
import "core:math/bits"
import "core:mem"
import "core:slice"
import "core:sort"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 5

@(private = "file")
MapRule :: struct {
	start, end: i64,
	offset:     i64,
}

@(private = "file")
map_rule_compare :: proc(a, b: MapRule) -> bool {
	return a.start < b.start
}

@(private = "file")
Map :: [dynamic]MapRule

@(private = "file")
NMAPS :: 7

@(private = "file")
SeedRange :: struct {
	start, end: i64,
}


day05 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: i64
	seeds, mappings := parse_input(input)
	defer {
		delete(seeds)
		for m in mappings do delete(m)
	}
	part1 = get_min_location_p1(seeds, mappings)
	seed_ranges: [dynamic]SeedRange
	defer delete(seed_ranges)
	for i := 0; i < len(seeds); i += 2 {
		append(&seed_ranges, SeedRange{start = seeds[i], end = seeds[i] + seeds[i + 1]})
	}
	part2 = get_min_location_p2(seed_ranges[:], mappings)
	return part1, part2
}

@(private = "file")
parse_input :: proc(input: string) -> (seeds: []i64, mappings: [NMAPS]Map) {
	lines := strings.split_lines(input)
	lines = lines[:len(lines) - 1]
	seeds_fields := strings.fields(lines[0][7:])
	seeds = slice.mapper(seeds_fields, read_i64)
	defer {
		delete(lines)
		delete(seeds_fields)
	}
	mi: int
	for i := 3; i < len(lines); i += 1 {
		line := lines[i]
		if line == "" {
			i, mi = i + 1, mi + 1
			continue
		}
		fields := strings.fields(line)
		nums := slice.mapper(fields, read_i64)
		start := nums[1]
		defer {
			delete(fields)
			delete(nums)
		}
		append(
			&mappings[mi],
			MapRule{start = start, end = start + nums[2], offset = nums[0] - start},
		)
		slice.sort_by(mappings[mi][:], map_rule_compare)
	}
	return
}

@(private = "file")
get_min_location_p1 :: proc(seeds: []i64, mappings: [NMAPS]Map) -> (min_location: i64) {
	min_location = bits.I64_MAX

	get_location :: proc(seed: i64, mappings: [NMAPS]Map) -> (location: i64) {
		location = seed
		for mapping in mappings {
			for range in mapping {
				if range.start <= location && location < range.end {
					location += range.offset
					break
				}
			}
		}
		return
	}

	for seed in seeds {
		location := get_location(seed, mappings)
		if location < min_location do min_location = location
	}
	return
}

@(private = "file")
get_min_location_p2 :: proc(
	seed_ranges: []SeedRange,
	mappings: [NMAPS]Map,
) -> (
	min_location: i64,
) {
	min_location = bits.I64_MAX
	prev_ranges: [dynamic]SeedRange
	append(&prev_ranges, ..seed_ranges)
	defer delete(prev_ranges)
	mapped_ranges: []SeedRange
	for mapping in mappings {
		mapped_ranges = map_ranges(prev_ranges[:], mapping)
		defer delete(mapped_ranges)
		clear(&prev_ranges)
		append(&prev_ranges, ..mapped_ranges[:])
	}
	for range in prev_ranges {
		if range.start < min_location do min_location = range.start
	}

	return
}

@(private = "file")
map_ranges :: proc(seed_ranges: []SeedRange, mapping: Map) -> []SeedRange {
	map_single_range :: proc(range: SeedRange, mapping: Map) -> []SeedRange {
		mapped: [dynamic]SeedRange
		new_seed_ranges: [dynamic]SeedRange
		defer delete(mapped)
		for rule in mapping {
			rstart := max(range.start, rule.start)
			rend := min(range.end, rule.end)
			if rstart < rend {
				append(
					&new_seed_ranges,
					SeedRange{start = rstart + rule.offset, end = rend + rule.offset},
				)
				append(&mapped, SeedRange{start = rstart, end = rend})
			}
		}
		pointer := range.start
		for mrange in mapped[:] {
			if pointer < mrange.start do append(&new_seed_ranges, SeedRange{pointer, mrange.start})
			pointer = mrange.end
		}
		if pointer < range.end do append(&new_seed_ranges, SeedRange{pointer, range.end})
		return new_seed_ranges[:]
	}

	new_seed_ranges: [dynamic]SeedRange
	for seed_range in seed_ranges {
		mapped_range := map_single_range(seed_range, mapping)
		defer delete(mapped_range)
		append(&new_seed_ranges, ..mapped_range[:])
	}
	return new_seed_ranges[:]
}


@(private = "file")
test_input :: `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
`

@(test)
test_example_d05_p1 :: proc(t: ^testing.T) {
	part1, _ := day05(test_input)
	part1_expected := i64(35)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d05_p2 :: proc(t: ^testing.T) {
	_, part2 := day05(test_input)
	part2_expected := i64(46)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day05 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day05 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day05(string(options.input))
	}
	options.count = options.rounds
	return nil
}
