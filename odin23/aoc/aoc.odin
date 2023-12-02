package aoc

import "core:fmt"
import "core:strings"
import "core:os"
import "core:mem"
import "core:mem/virtual"
import "core:time"

day_proc :: proc(string) -> (result_t, result_t)
result_t :: union {
    int,
    u64,
    string
}

run :: proc(day: string, procedure: day_proc, iter: int = 1) -> f64 {
    home := os.get_env("HOME")
    defer delete(home)

    filename := strings.concatenate({home, "/.aoc_data/2023/", day, ".in"})
    defer delete(filename)

    content, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Could not read file: ", filename)
        return 0
    }; defer delete(content)
    
    arena: virtual.Arena
    prev_allocator: mem.Allocator

    assert(virtual.arena_init_growing(&arena) == virtual.Allocator_Error.None)
    prev_allocator, context.allocator = context.allocator, virtual.arena_allocator(&arena)
    defer {
        context.allocator = prev_allocator
        virtual.arena_destroy(&arena)
    }

    acc: f64 = 0
    part1, part2: result_t
    for i in 0..<iter {
        content_copy := make([]u8, len(content))
        copy(content_copy, content)
        stopwatch: time.Stopwatch

        time.stopwatch_start(&stopwatch)
        part1, part2 = procedure(string(content_copy))
        time.stopwatch_stop(&stopwatch)

        acc += time.duration_milliseconds(stopwatch._accumulation)
        virtual.arena_free_all(&arena)
    }

    average_time := acc / f64(iter)

    fmt.printf("%s | %fms\n", day, average_time)
    fmt.printf("    part 1: %v\n", part1)
    fmt.printf("    part 2: %v\n", part2)
    return average_time
}

main :: proc() {
    days := map[string]day_proc {
        "day1" = day01,
    }; defer delete(days)

    iter := 1
    args := os.args; defer delete(args)
    for i in 0..<len(args) {
        if strings.compare(os.args[i],"--bench") == 0 {
            iter = 100
        }
    }
    
    total_time: f64
    for day, procedure in days do total_time += run(day, procedure, iter)

    fmt.printf("\ntotal | %fms\n", total_time)
}
