package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 7

@(private = "file")
Hand :: struct {
	bid:   int,
	eval:  u32,
	evalj: u32,
}

@(private = "file")
HandType :: enum {
	HIGH      = 1 << 25,
	ONEPAIR   = 1 << 26,
	TWOPAIR   = 1 << 27,
	THREE     = 1 << 28,
	FULLHOUSE = 1 << 29,
	FOUR      = 1 << 30,
	FIVE      = 1 << 31,
}

day07 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: int
	it := input[:]
	hands: [dynamic]Hand
	defer delete(hands)
	for line in strings.split_lines_iterator(&it) {
		hand, _, bid := strings.partition(line, " ")
		eval, evalj := evaluate_hand(hand)
		append(
			&hands,
			Hand {
				bid = strconv.atoi(bid),
				eval = eval,
				evalj = evalj,
			},
		)
	}
	hands_sl := hands[:]
	slice.sort_by(hands_sl, proc(a, b: Hand) -> bool {return a.eval < b.eval})
	for hand, i in hands_sl do part1 += hand.bid * (i + 1)

	slice.sort_by(hands_sl, proc(a, b: Hand) -> bool {return a.evalj < b.evalj})
	for hand, i in hands_sl do part2 += hand.bid * (i + 1)
	return part1, part2
}

@(private = "file")
maximum_two :: proc(amounts: []u8) -> (max, smax: u8) {
    for n in amounts {
        if n > max {
            smax = max
            max = n
        } else if n > smax {
                smax = n
            }
    }
    return
}

@(private = "file")
card_strength :: proc(card: byte) -> int {
    switch card {
    case 'A':
        return 12
    case 'K':
        return 11
    case 'Q':
        return 10
    case 'J':
        return 9
    case 'T':
        return 8
    case:
        return int(card - '0' - 2)
    }
}

@(private = "file")
card_strength_joker :: proc(card: byte) -> int {
    switch card {
    case 'A':
        return 12
    case 'K':
        return 11
    case 'Q':
        return 10
    case 'T':
        return 9
    case 'J':
        return 0
    case:
        return int(card - '0' - 1)
    }
}

get_type :: proc(max, smax: u8) -> HandType {
	switch max {
	case 5:
		return .FIVE
	case 4:
		return .FOUR
	case 3:
		return smax == 2 ? .FULLHOUSE : .THREE
	case 2:
		return smax == 2 ? .TWOPAIR : .ONEPAIR
	case:
		return .HIGH
	}
}

@(private = "file")
evaluate_hand :: proc(hand: string) -> (eval: u32, evalj: u32) {
	amounts: [13]u8
    powers := [5]int{1, 13, 169, 2197, 28561}
	for i in 0 ..< 5 {
		strength := card_strength(hand[i])
        strengthj := card_strength_joker(hand[i])
		eval += u32(strength * powers[4 - i])
        evalj += u32(strengthj * powers[4 - i])
		amounts[strengthj] += 1
	}
	max, smax := maximum_two(amounts[:])
    maxj, smaxj := maximum_two(amounts[1:])
    jokers := amounts[0]
    eval |= u32(get_type(max, smax))
    evalj |= u32(get_type(maxj + jokers, smaxj))
	return
}

@(private = "file")
test_input :: `32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
`

@(test)
test_example_d07_p1 :: proc(t: ^testing.T) {
	part1, _ := day07(test_input)
	part1_expected := int(6440)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d07_p2 :: proc(t: ^testing.T) {
	_, part2 := day07(test_input)
	part2_expected := int(5905)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day07 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day07 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day07(string(options.input))
	}
	options.count = options.rounds
	return nil
}
