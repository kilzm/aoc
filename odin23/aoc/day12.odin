package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 12

day12 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	it := input[:]
	M :: 5
	for line in strings.split_lines_iterator(&it) {
		springs, _, group_str := strings.partition(line, " ")
		groups_split := strings.split(group_str, ",")
		groups := make([]int, len(groups_split))
		for group, i in groups_split do groups[i] = read_int(group)
		springs_len, groups_len := len(springs), len(groups)
		springs_unfolded_len, groups_unfolded_len := M * (springs_len + 1), M * groups_len
		springs_unfolded := make([]u8, springs_unfolded_len)
		groups_unfolded := make([]int, groups_unfolded_len)
		for i in 0 ..< M {
			sbegin, gbegin := i * (springs_len + 1), i * groups_len
			send := sbegin + springs_len
			copy(springs_unfolded[sbegin:send], transmute([]u8)springs)
			springs_unfolded[send] = '?'
			copy(groups_unfolded[gbegin:gbegin + groups_len], groups)
		}
		defer {
			delete(groups_split)
			delete(groups)
			delete(springs_unfolded)
			delete(groups_unfolded)
		}
		part1 += calculate_arrangements(springs, groups)
		part2 += calculate_arrangements(
			string(springs_unfolded[:springs_unfolded_len - 1]),
			groups_unfolded[:],
		)
	}
	return part1, part2
}

@(private = "file")
calculate_arrangements :: proc(springs: string, groups: []int) -> (n_arrangements: int) {
	tsprings := fmt.aprintf(".%s", strings.trim_right(springs, "."))
	defer delete(tsprings)
	dp := make([]int, len(tsprings) + 1)
	defer delete(dp)
	dp[0] = 1
	for c, i in tsprings {
		if c == '#' do break
		dp[i + 1] = 1
	}
	for group in groups {
		dp_n := make([]int, len(tsprings) + 1)
		defer delete(dp_n)
		chunk: int
		for c, i in tsprings {
			chunk = chunk + 1 if c != '.' else 0
			if c != '#' do dp_n[i + 1] += dp_n[i]
			if chunk >= group && tsprings[i - group] != '#' do dp_n[i + 1] += dp[i - group]
		}
		copy(dp, dp_n)
	}
	return dp[len(dp) - 1]
}

@(private = "file")
test_input :: `???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
`

@(test)
test_example_d12_p1 :: proc(t: ^testing.T) {
	part1, _ := day12(test_input)
	part1_expected := int(21)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d12_p2 :: proc(t: ^testing.T) {
	_, part2 := day12(test_input)
	part2_expected := int(525152)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day12 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day12 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day12(string(options.input))
	}
	options.count = options.rounds
	return nil
}
