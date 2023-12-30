package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"
import "core:math/bits"
import "core:slice"

@(private = "file")
DAY :: 16

@(private = "file")
Step :: struct {
    pos, dir: [2]int
}

@(private = "file")
Dir :: enum {
    WEST = -2,
    NORTH = -1,
    SOUTH = 1,
    EAST = 2,
}

@(private = "file")
Seen :: struct {
    n, e, s, w: [110]u128
}

@(private = "file")
Edges :: struct {
    n, e, s, w: u128
}

day16 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
    grid := strings.split_lines(input[0:len(input) - 1])
    defer delete(grid)
    rows, cols := len(grid), len(grid[0])
    edges: Edges
    part1 = get_energized(grid, rows, cols, {0, 0}, {0, 1}, &edges)
    part2 = part1
    for c in 0 ..< cols {
        mask: u128 = 1 << u32(c)
        if edges.n & mask == 0 {
            part2 = max(part2, get_energized(grid, rows, cols, {0, c}, {1, 0}, &edges))
        }
        if edges.s & mask == 0 {
            part2 = max(part2, get_energized(grid, rows, cols, {rows - 1, c}, {-1, 0}, &edges))
        }
    }
    for r in 0 ..< rows {
        mask: u128 = 1 << u32(r)
        if edges.w & mask == 0 {
            part2 = max(part2, get_energized(grid, rows, cols, {r, 0}, {0, 1}, &edges))
        }
        if edges.e & mask == 0 {
            part2 = max(part2, get_energized(grid, rows, cols, {r, cols - 1}, {0, -1}, &edges))
        }
    }
	return part1, part2
}

@(private = "file")
get_energized :: proc(grid: []string, rows, cols: int, start: [2]int, dir: [2]int, edges: ^Edges) -> (energized: int) {
    seen := Seen {}
    steps := make([dynamic]Step)
    update_steps(&steps, grid[start.x][start.y], start, dir, Dir (dir.x + 2 * dir.y))
    defer delete(steps)
    for len(steps) > 0 {
        step := pop(&steps)
        r, c := step.pos.x, step.pos.y
        dir: Dir = Dir (step.dir.x + 2 * step.dir.y)
        mask: u128 = 1 << u32(c)
        seenp: ^u128
        switch dir {
            case .NORTH:
                seenp = &seen.n[r]
            case .EAST:
                seenp = &seen.e[r]
            case .SOUTH:
                seenp = &seen.s[r]
            case .WEST:
                seenp = &seen.w[r]
        }
        if seenp^ & mask != 0 do continue
        seenp^ |= mask
        next := step.pos + step.dir
        switch {
            case next.x < 0:
                edges.n |= 1 << u32(step.pos.y)
            case next.x >= rows:
                edges.s |= 1 << u32(step.pos.y)
            case next.y < 0:
                edges.w |= 1 << u32(step.pos.x)
            case next.y >= cols:
                edges.e |= 1 << u32(step.pos.x)
            case:
                update_steps(&steps, grid[next.x][next.y], next, step.dir, dir)
        }
    }
    for _, r in seen.n {
        seen_r := seen.n[r] | seen.e[r] | seen.s[r] | seen.w[r]
        energized += int(bits.count_ones(seen_r))
    }
    return 
}

@(private = "file")
update_steps :: proc(steps: ^[dynamic]Step, symbol: u8, next: [2]int, sdir: [2]int, dir: Dir) {
    switch symbol {
        case '.':
            append(steps, Step {next, sdir})
        case '/':
            append(steps, Step {next, {-sdir.y, -sdir.x}})
        case '\\':
            append(steps, Step {next, {sdir.y, sdir.x}})
        case '|':
            switch dir {
                case .NORTH, .SOUTH:
                    append(steps, Step {next, sdir})
                case .WEST, .EAST:
                    append(steps, Step {next, {1, 0}})
                    append(steps, Step {next, {-1, 0}})
            }
        case '-':
            switch dir {
                case .NORTH, .SOUTH:
                    append(steps, Step {next, {0, 1}})
                    append(steps, Step {next, {0, -1}})
                case .WEST, .EAST:
                    append(steps, Step {next, sdir})
            }
    }
}

@(private = "file")
test_input :: `.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
`

@(test)
test_example_d16_p1 :: proc(t: ^testing.T) {
	part1, _ := day16(test_input)
	part1_expected := int(46)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d16_p2 :: proc(t: ^testing.T) {
	_, part2 := day16(test_input)
	part2_expected := int(51)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day16 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day16 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day16(string(options.input))
	}
	options.count = options.rounds
	return nil
}
