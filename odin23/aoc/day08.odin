package aoc

import "core:fmt"
import "core:math"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 8

@(private = "file")
Destinations :: struct {
	left, right: u32,
}

day08 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	instructions, network, starts := parse_input(input)
	defer {
		delete(instructions)
		delete(network)
		delete(starts)
	}
	part1 = solve_p1(instructions, network)
	part2 = solve_p2(instructions, network, starts)
	return part1, part2
}

@(private = "file")
solve_p1 :: proc(instructions: []bool, network: map[u32]Destinations) -> (steps: int) {
	n_instructions := len(instructions)
	AAA := convert_location("AAA")
	ZZZ := convert_location("ZZZ")
	location := AAA
	for {
		go_left := instructions[steps %% n_instructions]
		if go_left {
			location = network[location].left
		} else {
			location = network[location].right
		}
		steps += 1
		if location == ZZZ do break
	}
	return
}

@(private = "file")
solve_p2 :: proc(
	instructions: []bool,
	network: map[u32]Destinations,
	starts: []u32,
) -> (
	steps: int,
) {
	n_instructions := len(instructions)
	path_lens: [dynamic]int
	defer delete(path_lens)
	START :: u32(1 << 31)
	END :: u32(1 << 30)
	for location in starts {
		csteps: int
		clocation := location
		for {
			go_left := instructions[csteps %% n_instructions]
			if go_left {
				clocation = network[clocation].left
			} else {
				clocation = network[clocation].right
			}
			csteps += 1
			if clocation & END != 0 do break
		}
		append(&path_lens, csteps)
	}
	steps = path_lens[0]
	for path_len in path_lens {
		steps = math.lcm(steps, path_len)
	}
	return
}

@(private = "file")
convert_location :: proc(location: string) -> (value: u32) {
	loc := transmute([]u8)location
	for c, i in loc do value += u32(c - 'A') * u32(ipow(26, u32(2 - i)))
	if loc[2] == 'A' {
		value |= 1 << 31
	} else if loc[2] == 'Z' {
		value |= 1 << 30
	}
	return
}

@(private = "file")
parse_input :: proc(
	input: string,
) -> (
	instructions: []bool,
	network: map[u32]Destinations,
	starts_: []u32,
) {
	lines := strings.split_lines(input)
	defer delete(lines)
	starts := make([dynamic]u32)
	instructions = make([]bool, len(lines[0]))
	for instruction, i in lines[0] do instructions[i] = instruction == 'L'
	for line in lines[2:len(lines) - 1] {
		from := convert_location(line[:3])
		network[from] = Destinations {
			left  = convert_location(line[7:10]),
			right = convert_location(line[12:15]),
		}
		if from & (1 << 31) != 0 do append(&starts, from)
	}
	starts_ = starts[:]
	return
}

@(private = "file")
test_input_p1 :: `LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
`

@(test)
test_example_d08_p1 :: proc(t: ^testing.T) {
	instructions, network, _ := parse_input(test_input_p1)
	defer {
		delete(instructions)
		delete(network)
	}
	part1 := solve_p1(instructions, network)
	part1_expected := int(6)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(private = "file")
test_input_p2 :: `LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
`

@(test)
test_example_d08_p2 :: proc(t: ^testing.T) {
	instructions, network, starts := parse_input(test_input_p2)
	defer {
		delete(instructions)
		delete(network)
	}
	part2 := solve_p2(instructions, network, starts)
	part2_expected := int(6)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day08 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day08 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day08(string(options.input))
	}
	options.count = options.rounds
	return nil
}
