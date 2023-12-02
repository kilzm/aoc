package aoc

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

day02 :: proc(content: string) -> (result_t, result_t) {
	part1, part2: int
	lines := strings.split(content, "\n");defer delete(lines)
	for line, i in lines[:len(lines) - 1] {
		sample_strs := strings.split(line[strings.index(line, ":") + 2:], "; ")
		defer delete(sample_strs)
		if check_game(sample_strs) do part1 += i + 1
		part2 += get_power_for_game(sample_strs)
	}
	return part1, part2
}

@(private = "file")
check_game :: proc(samples: []string) -> bool {
	for sample in samples {
		csamples := strings.split(sample, ", ");defer delete(csamples)
		for csample in csamples {
			split := strings.split(csample, " ");defer delete(split)
			color := split[1][0]
			amount := strconv.atoi(split[0])
			if (color == 'r' && amount > 12 ||
				   color == 'g' && amount > 13 ||
				   color == 'b' && amount > 14) {
				return false
			}
		}
	}
	return true
}

@(private = "file")
get_power_for_game :: proc(samples: []string) -> int {
	red, green, blue: int
	for sample in samples {
		csamples := strings.split(sample, ", ");defer delete(csamples)
		for csample in csamples {
			split := strings.split(csample, " ");defer delete(split)
			color := split[1][0]
			amount := strconv.atoi(split[0])
			switch color {
			case 'r':
				red = max(red, amount)
			case 'g':
				green = max(green, amount)
			case 'b':
				blue = max(blue, amount)
			}
		}
	}
	return red * green * blue
}

@(test)
test_example_d02_p1 :: proc(t: ^testing.T) {
	input := strings.join(
		 {
			"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
			"Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
			"Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
			"Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
			"Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
			"",
		},
		"\n",
	);defer delete(input)

	part1, _ := day02(input)
	part1_expected := int(8)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d02_p2 :: proc(t: ^testing.T) {
	input := strings.join(
		 {
			"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
			"Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
			"Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
			"Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
			"Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
			"",
		},
		"\n",
	);defer delete(input)

	_, part2 := day02(input)
	part2_expected := int(2286)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}
