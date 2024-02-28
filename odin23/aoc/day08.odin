//+private file
package aoc

import "core:fmt"
import "core:math"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 8

@(private)
day08 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	instructions, network, starts := parse(input)
	defer {
		delete(network)
		delete(starts)
		delete(instructions)
	}
	part1 = solve_p1(instructions, network)
	part2 = solve_p2(instructions, network, starts)
	return part1, part2
}

solve_p1 :: proc(instructions: []u8, network: []u32) -> (steps: int) {
	n_instructions := len(instructions)
	AAA := encode("AAA")
	ZZZ := encode("ZZZ")
	location := AAA
	ci: int
	for {
		if ci >= n_instructions do ci = 0
		instr := instructions[ci]
		location = network[location] >> 16 if instr == 'L' else network[location] & 0xFFFF
		steps += 1
		ci += 1
		if location == ZZZ do break
	}
	return
}

solve_p2 :: proc(instructions: []u8, network: []u32, starts: []u32) -> (steps: int = 1) {
	n_instructions := len(instructions)
	for location in starts {
		csteps: int
		clocation := location
		for {
			instr := instructions[csteps %% n_instructions]
			clocation = network[clocation] >> 16 if instr == 'L' else network[clocation] & 0xFFFF
			csteps += 1
			if clocation & 0b11111 == u32('Z' - 'A') do break
		}
		steps = math.lcm(steps, csteps)
	}
	return
}

encode :: #force_inline proc(location: string) -> (value: u32) {
	loc := transmute([]u8)location
	value |= u32(loc[0] - 'A') << 10 | u32(loc[1] - 'A') << 5 | u32(loc[2] - 'A')
	return
}

parse :: proc(input: string) -> (instructions: []u8, network: []u32, starts_: []u32) {
	lines := strings.split_lines(input)
	defer delete(lines)
	instructions = make([]u8, len(lines[0]))
	copy(instructions, lines[0])
	starts := make([dynamic]u32)
	network = make([]u32, 0b11001_11001_11001 + 1)
	for line in lines[2:len(lines) - 1] {
		from, left, right := encode(line[:3]), encode(line[7:10]), encode(line[12:15])
		network[from] = left << 16 | right
		if line[2] == 'A' do append(&starts, from)
	}
	starts_ = starts[:]
	return
}

test_input_p1 :: `LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
`

@(test, private)
test_example_d08_p1 :: proc(t: ^testing.T) {
	instructions, network, _ := parse(test_input_p1)
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

test_input_p2 :: `LR

GGA = (GGB, XXX
GGB = (XXX, GGZ)
GGZ = (GGB, XXX)
HHA = (HHB, XXX)
HHB = (HHC, HHC)
HHC = (HHZ, HHZ)
HHZ = (HHB, HHB)
XXX = (XXX, XXX)
`

@(test, private)
test_example_d08_p2 :: proc(t: ^testing.T) {
	instructions, network, starts := parse(test_input_p2)
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

@(private)
setup_day08 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
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
