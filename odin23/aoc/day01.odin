package aoc

import "core:strings"
import "core:fmt"
import "core:unicode"
import "core:unicode/utf8"
import "core:testing"

day01 :: proc(content: string) -> (result_t, result_t) {
    lines := strings.split_lines(content)
    part1: int
    part2: int
    for line in lines {
        part1 += get_calibration_value(line)
        replaced := replace_all_spelled(line)
        a := get_calibration_value(replaced)
        part2 += a
    }
    return part1, part2
}


get_calibration_value :: proc(line: string) -> int {
    calibration_value: int
    for c in line {
        if unicode.is_digit(c) {
            calibration_value += (int(c) - 48) * 10
            break
        }
    }
    #reverse for c in line {
        if unicode.is_digit(c) {
            calibration_value += (int(c) - 48)
            break
        }
    }
    return calibration_value
}

replace_all_spelled :: proc(line: string) -> string {
    result := line
    result, _ = strings.replace_all(result, "one", "one1one")
    result, _ = strings.replace_all(result, "two", "two2two")
    result, _ = strings.replace_all(result, "three", "three3three")
    result, _ = strings.replace_all(result, "four", "four4four")
    result, _ = strings.replace_all(result, "five", "five5five")
    result, _ = strings.replace_all(result, "six", "six6six")
    result, _ = strings.replace_all(result, "seven", "seven7seven")
    result, _ = strings.replace_all(result, "eight", "eight8eight")
    result, _ = strings.replace_all(result, "nine", "nine9nine")
    return result
}

@test
test_part1_example :: proc(t: ^testing.T) {
    input := strings.join(
        { 
            "1abc2",
            "a1b2c3d4e5f",
            "pqr3stu8vwx",
            "treb7uch",
        }, "\n"); defer delete(input)

    part1, _ := day01(input)
    part1_expected := int(142)
    testing.expect(t, part1 == part1_expected, fmt.tprintf("Expected %v, got %v", part1_expected, part1))
}

@test
test_part_2_example :: proc(t: ^testing.T) {
    input := strings.join({ 
        "two1nine",
        "eightwothree",
        "abcone2threexyz",
        "xtwone3four",
        "4nineeightseven2",
        "zoneight234",
        "7pqrstsixteen" },
    "\n"); defer delete(input)

    _, part2 := day01(input)
    part2_expected := int(281)
    testing.expect(t, part2 == part2_expected, fmt.tprintf("Expected %v, got %v", part2_expected, part2))
}
