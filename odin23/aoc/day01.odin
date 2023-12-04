package aoc

import "core:fmt"
import "core:testing"
import "core:time"
import "core:strings"
import "core:unicode"
import "core:unicode/utf8"

@(private = "file")
DAY :: 1

day01 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	it := input[:]
	for line in strings.split_lines_iterator(&it) {
		part1 += get_calibration_value(line)
		part2 += get_actual_calibration_value(line)
	}
	return part1, part2
}

@(private = "file")
get_calibration_value :: proc(line: string) -> int {
	calibration_value: int
	for c in line {
		if unicode.is_digit(c) {
			calibration_value += rune_to_int(c) * 10
			break
		}
	}
	#reverse for c in line {
		if unicode.is_digit(c) {
			calibration_value += rune_to_int(c)
			break
		}
	}
	return calibration_value
}

@(private = "file")
get_actual_calibration_value :: proc(line: string) -> int  {
	spelled :: []string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
	get_first_digit :: proc(line: string) -> int {
		for i := 0; i < len(line); i += 1 {
            substr := line[i:]
			if c := utf8.rune_at(substr, 0); unicode.is_digit(c) {
				return rune_to_int(c)
			}
			for sp, i in spelled {
				if strings.has_prefix(substr, sp) {
					return i + 1
				}
			}
		}
		return 0
	}
	get_last_digit :: proc(line: string) -> int {
		for i := len(line); i > 0; i -= 1 {
			substr := line[:i]
			if c := utf8.rune_at(substr, i - 1); unicode.is_digit(c) {
				return rune_to_int(c)
			}
			for sp, i in spelled {
				if strings.has_suffix(substr, sp) {
					return i + 1
				}
			}
		}
		return 0
	}
	return get_first_digit(line) * 10 + get_last_digit(line)
}

@(private = "file")
test_input_p1 :: 
`pqr3stu8vwx
1abc2
a1b2c3d4e5f
treb7uchet`

@(test)
test_example_d01_p1 :: proc(t: ^testing.T) {
	part1, _ := day01(test_input_p1)
	part1_expected := int(142)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(private = "file")
test_input_p2 :: 
`two1nine
eightwothree
abcone2threextz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen`



@(test)
test_example_d01_p2 :: proc(t: ^testing.T) {
	_, part2 := day01(test_input_p2)
	part2_expected := int(281)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day01 :: proc(options: ^time.Benchmark_Options, allocator := context.allocator) -> time.Benchmark_Error {
    options.input = get_input(DAY)
    return nil
}

bench_day01 :: proc(options: ^time.Benchmark_Options, allocator := context.allocator) -> time.Benchmark_Error {
    for _ in 0..<options.rounds {
        _, _ = day01(string(options.input))
    }
    options.count = options.rounds
    return nil
}
