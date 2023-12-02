package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"
import "core:unicode"
import "core:unicode/utf8"

day01 :: proc(content: string) -> (result_t, result_t) {
	part1, part2: int
	lines := strings.split_lines(content)
	defer delete(lines)
	for line in lines {
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
get_actual_calibration_value :: proc(line: string) -> int {
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

@(test)
test_example_d01_p1 :: proc(t: ^testing.T) {
	input := strings.join(
		{"1abc2", "a1b2c3d4e5f", "pqr3stu8vwx", "treb7uch"},
		"\n",
	);defer delete(input)

	part1, _ := day01(input)
	part1_expected := int(142)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d01_p2 :: proc(t: ^testing.T) {
	input := strings.join(
		 {
			"two1nine",
			"eightwothree",
			"abcone2threexyz",
			"xtwone3four",
			"4nineeightseven2",
			"zoneight234",
			"7pqrstsixteen",
		},
		"\n",
	);defer delete(input)

	_, part2 := day01(input)
	part2_expected := int(281)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}
