package aoc

import "core:fmt"
import "core:testing"
import "core:time"
import "core:strings"
import "core:unicode"
import "core:strconv"

@(private = "file")
DAY :: 3

Gear :: struct {
    nums: [2]int,
    amount: int
}

day03 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
    schematic := strings.split_lines(input)
    gears := make(map[int]Gear)
    defer {
        delete(schematic)
        delete(gears)
    } 
    nrows, ncols := len(schematic) - 1, len(schematic[0])
    for line, row in schematic  {
        num_beg: int
        on_num: bool
        for char, col in line {
            if unicode.is_digit(char) {
                if !on_num {
                    on_num = true
                    num_beg = col
                }
            } else if on_num {
                on_num = false
                is_parts_num: bool
                #no_bounds_check num := strconv.atoi(line[num_beg:col])
                for rr in row-1..=row+1 {
                    if rr < 0 || rr >= nrows do continue
                    for cc in num_beg-1..=col {
                        within_bounds := 0 <= cc && cc < ncols
                        part_of_num := rr == row && num_beg <= cc && cc < col
                        if !within_bounds || part_of_num do continue
                        #no_bounds_check symbol := schematic[rr][cc]
                        if symbol != '.' do is_parts_num = true
                        if symbol == '*' do update_gears(&gears, rr * nrows + cc, num)
                    }
                }
                if is_parts_num do part1 += num
            }
        }
    }
    for _, gear in gears {
        if gear.amount == 2 do part2 += gear.nums[0] * gear.nums[1]
    }
	return part1, part2
}

@(private = "file")
update_gears :: proc(gears: ^map[int]Gear, index, num: int) {
    gear := &gears[index]
    if &gears[index] == nil {
        gears[index] = Gear {}
        gear = &gears[index]
    }
    amount := gear.amount
    if (gear.amount < 2) do gear.nums[amount] = num
    gear.amount += 1
}

@(private = "file")
test_input ::
`467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`

@(test)
test_example_d03_p1 :: proc(t: ^testing.T) {
	part1, _ := day03(test_input)
	part1_expected := int(4361)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d03_p2 :: proc(t: ^testing.T) {
	_, part2 := day03(test_input)
	part2_expected := int(467835)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day03 :: proc(options: ^time.Benchmark_Options, allocator := context.allocator) -> time.Benchmark_Error {
    options.input = get_input(DAY)
    return nil
}

bench_day03 :: proc(options: ^time.Benchmark_Options, allocator := context.allocator) -> time.Benchmark_Error {
    for _ in 0..<options.rounds {
        _, _ = day03(string(options.input))
    }
    options.count = options.rounds
    return nil
}
