//+private file
package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:time"

DAY :: 9

@(private)
day09 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	seqs, seqlen := parse(input)
	defer delete(seqs)
	for seq in seqs {
		dseqs := make([dynamic][]int)
		defer delete(dseqs)
		append(&dseqs, seq)
		depth := 1
		for {
			tseq := dseqs[len(dseqs) - 1]
			if slice.all_of(tseq, 0) do break
			dseq := make([]int, seqlen)
			for i := 0; i < len(seq) - depth; i += 1 {
				dseq[i] = tseq[i + 1] - tseq[i]
			}
			append(&dseqs, dseq)
			depth += 1
		}
		acc: int
		#reverse for dseq in dseqs {
			part1 += dseq[seqlen - depth]
			acc = dseq[0] - acc
			depth -= 1
			delete(dseq)
		}
		part2 += acc
	}

	return part1, part2
}

parse :: proc(input: string) -> (seqs: [dynamic][]int, seqlen: int) {
	lines := strings.split_lines(input)
	defer delete(lines)
	seqlen = slice.count(transmute([]u8)lines[0], ' ') + 1
	for line in lines[:len(lines) - 1] {
		line_it := line[:]
		seq := make([]int, seqlen)
		i: int
		for field in strings.fields_iterator(&line_it) {
			seq[i] = strconv.atoi(field)
			i += 1
		}
		append(&seqs, seq)
	}
	return
}

test_input :: `0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
`

@(test, private)
test_example_d09_p1 :: proc(t: ^testing.T) {
	part1, _ := day09(test_input)
	part1_expected := int(114)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test, private)
test_example_d09_p2 :: proc(t: ^testing.T) {
	_, part2 := day09(test_input)
	part2_expected := int(2)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

@(private)
setup_day09 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

@(private)
bench_day09 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day09(string(options.input))
	}
	options.count = options.rounds
	return nil
}
