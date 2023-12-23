package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 4

@(private = "file")
Layout :: struct {
	wstart, n_wnums, nstart, n_nums: int,
}

day04 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	layout := determine_layout(input[:strings.index_rune(input, '\n')])
	lines := strings.split_lines(input)
	num_cards := len(lines) - 1
	lines = lines[:num_cards]
	wnums, nums := make([]int, layout.n_wnums), make([]int, layout.n_nums)
	scores, counts := make([]int, num_cards), make([]int, num_cards)
	defer {
		delete(lines)
		delete(wnums)
		delete(nums)
		delete(scores)
		delete(counts)
	}
	for line, i in lines {
		fill_nums(line, wnums, nums, layout)
		count, score := get_count_and_score(wnums, nums)
		counts[i] += 1
		for card in i + 1 ..= i + count {
			counts[card] += counts[i]
		}
		scores[i] = score
	}
	for i in 0 ..< num_cards {
		part1 += scores[i]
		part2 += counts[i]
	}
	return part1, part2
}

@(private = "file")
determine_layout :: proc(line: string) -> (layout: Layout) {
	colon := strings.index_rune(line, ':')
	layout.wstart = colon + 2
	pipe := layout.wstart + strings.index_rune(line[layout.wstart:], '|')
	layout.nstart = pipe + 2
	layout.n_wnums = (pipe - colon - 2) / 3
	layout.n_nums = (len(line) - pipe - 1) / 3
	return
}

@(private = "file")
fill_nums :: proc(line: string, wnums, nums: []int, layout: Layout) {
	index := layout.wstart
	for i in 0 ..< layout.n_wnums {
		num :=
			line[index] == ' ' \
			? strconv.atoi(line[index + 1:][:1]) \
			: strconv.atoi(line[index:][:2])
		index += 3
		wnums[i] = num
	}
	index = layout.nstart
	for i in 0 ..< layout.n_nums {
		num :=
			line[index] == ' ' \
			? strconv.atoi(line[index + 1:][:1]) \
			: strconv.atoi(line[index:][:2])
		index += 3
		nums[i] = num
	}
}

@(private = "file")
lut := [?]int{0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024}

@(private = "file")
get_count_and_score :: proc(wnums, nums: []int) -> (count, score: int) {
	for num in nums {
		if slice.contains(wnums, num) do count += 1
	}
	score = lut[count]
	return
}

@(private = "file")
test_input :: `Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
`

@(test)
test_example_d04_p1 :: proc(t: ^testing.T) {
	part1, _ := day04(test_input)
	part1_expected := int(13)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d04_p2 :: proc(t: ^testing.T) {
	_, part2 := day04(test_input)
	part2_expected := int(30)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day04 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day04 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day04(string(options.input))
	}
	options.count = options.rounds
	return nil
}
