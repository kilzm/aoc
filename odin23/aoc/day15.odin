package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 15

@(private = "file")
Lens :: struct {
    label: string,
    focal: u8,
}

@(private = "file")
Box :: struct {
    lenses: [dynamic]Lens,
}

day15 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: u64
    it := input[:len(input) - 1]
    boxes: [256]Box
    defer for box in boxes do delete(box.lenses)
    for step in strings.split_iterator(&it, ",") {
        part1 += hash(step)
        l := len(step)
        is_remove := step[l - 1] == '-'
        label := step[:l - 1] if is_remove else step[:l - 2]
        index := hash(label)
        if !is_remove {
            focal := step[l - 1] - '0'
            replaced: bool
            for lens, i in boxes[index].lenses {
                 if lens.label == label {
                    boxes[index].lenses[i].focal = focal
                    replaced = true
                    break
                }
            }
            if !replaced do append(&boxes[index].lenses, Lens {label, focal})
        } else {
            for lens, i  in boxes[index].lenses {
                if lens.label == label do ordered_remove(&boxes[index].lenses, i)
            }
        }
    }
    for box, bi in boxes {
        for lens, li  in box.lenses {
            part2 += u64(bi + 1) * u64(li + 1) * u64(lens.focal)
        }
    }
	return part1, part2
}

@(private = "file")
hash :: proc(str: string) -> (hash: u64) {
    for c in 0 ..< len(str) do hash = (hash + u64(str[c])) * 17 %% 256
    return
}

@(private = "file")
test_input :: `rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
`

@(test)
test_example_d15_p1 :: proc(t: ^testing.T) {
	part1, _ := day15(test_input)
	part1_expected := u64(1320)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d15_p2 :: proc(t: ^testing.T) {
	_, part2 := day15(test_input)
	part2_expected := u64(145)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day15 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day15 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day15(string(options.input))
	}
	options.count = options.rounds
	return nil
}
