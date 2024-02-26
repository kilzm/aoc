package aoc

import "core:fmt"
import "core:strings"
import "core:testing"
import "core:time"

@(private = "file")
DAY :: 19

@(private = "file")
Part :: distinct [4]u64

@(private = "file")
Action :: union {
	bool, // accepted
	string, // next workflow
}

@(private = "file")
Cond :: struct {
	var:      u8,
	from, to: u64,
	action:   Action,
}

@(private = "file")
Rule :: union {
	Action,
	Cond,
}

day19 :: proc(input: string) -> (result_t, result_t) {
	part1, part2: u64
	workflows, parts := parse(input)

	defer {
		delete(parts)
		for _, rules in workflows {
			delete(rules)
		}
		delete(workflows)
	}

	for part in parts {
		if validate(part, workflows) {
			part1 += part.x + part.y + part.z + part.w
		}
	}

	start := [2]Part{{1, 1, 1, 1}, {4001, 4001, 4001, 4001}}
	part2 = count(start, workflows["in"], 0, workflows)

	return part1, part2
}

@(private = "file")
parse :: #force_inline proc(
	input: string,
) -> (
	workflows: map[string][dynamic]Rule,
	parts: [dynamic]Part,
) {
	parse_action :: #force_inline proc(str: string) -> Action {
		if len(str) == 1 do return str[0] == 'A'
		return str
	}

	workflows = make(map[string][dynamic]Rule)
	it := input
	for line in strings.split_lines_iterator(&it) {
		if line == "" do break
		brace := strings.index_byte(line, '{')
		name := line[:brace]
		rstr := line[brace + 1:len(line) - 1]
		workflows[name] = make([dynamic]Rule)
		for r in strings.split_iterator(&rstr, ",") {
			rule: Rule
			colon := strings.index_byte(r, ':')
			if colon == -1 {
				rule = parse_action(r)
			} else {
				var: u8 = 0 if r[0] == 'x' else 1 if r[0] == 'm' else 2 if r[0] == 'a' else 3
				num := read_u64(r[2:colon])
				range: [2]u64 = {1, num} if r[1] == '<' else {num + 1, 4001}
				rule = Cond{var, range.x, range.y, parse_action(r[colon + 1:])}
			}
			append(&workflows[name], rule)
		}
	}

	parts = make([dynamic]Part)
	for line in strings.split_lines_iterator(&it) {
		pstr := line[3:len(line) - 1]
		index: u8
		part: Part
		for p in strings.split_iterator(&pstr, "=") {
			part[index] = read_u64(p[:len(p) - (2 if index != 3 else 0)])
			index += 1
		}
		append(&parts, part)
	}

	return
}

@(private = "file")
validate :: #force_inline proc(part: Part, workflows: map[string][dynamic]Rule) -> bool {
	wf := workflows["in"]
	for {
		loop: for rule in wf {
			switch r in rule {
			case Action:
				switch a in r {
				case bool:
					return a
				case string:
					wf = workflows[a]
					break loop
				}
			case Cond:
				if v := part[r.var]; r.from <= v && v < r.to {
					switch a in r.action {
					case bool:
						return a
					case string:
						wf = workflows[a]
						break loop
					}
				}
			}
		}
	}
}

@(private = "file")
count :: proc(
	ranges: [2]Part,
	wf: [dynamic]Rule,
	index: u8,
	workflows: map[string][dynamic]Rule,
) -> (
	combinations: u64,
) {
	prod :: #force_inline proc(ranges: [2]Part) -> (prod: u64 = 1) {
		#unroll for i in 0 ..< 4 do prod *= ranges.y[i] - ranges.x[i]
		return
	}

	action :: #force_inline proc(
		action: Action,
		ranges: [2]Part,
		workflows: map[string][dynamic]Rule,
	) -> (
		combinations: u64,
	) {
		switch a in action {
		case bool:
			if a do combinations = prod(ranges)
		case string:
			combinations = count(ranges, workflows[a], 0, workflows)
		}
		return
	}

	rule := wf[index]
	switch r in rule {
	case Action:
		combinations += action(r, ranges, workflows)
	case Cond:
		from := max(ranges.x[r.var], r.from)
		to := min(ranges.y[r.var], r.to)
		nranges := ranges
		if from >= to {
			combinations += count(ranges, wf, index + 1, workflows)
		} else {
			nranges.x[r.var], nranges.y[r.var] = from, to
			combinations += action(r.action, nranges, workflows)

			if f := ranges.x[r.var]; f < from {
				nranges.x[r.var], nranges.y[r.var] = f, from
				combinations += count(nranges, wf, index + 1, workflows)
			}

			if t := ranges.y[r.var]; to < t {
				nranges.x[r.var], nranges.y[r.var] = to, t
				combinations += count(nranges, wf, index + 1, workflows)
			}
		}
	}
	return combinations
}

@(private = "file")
test_input :: `px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}`

@(test)
test_example_d19_p1 :: proc(t: ^testing.T) {
	part1, _ := day19(test_input)
	part1_expected := u64(19114)
	testing.expect(
		t,
		part1 == part1_expected,
		fmt.tprintf("Expected %v, got %v", part1_expected, part1),
	)
}

@(test)
test_example_d19_p2 :: proc(t: ^testing.T) {
	_, part2 := day19(test_input)
	part2_expected := u64(167409079868000)
	testing.expect(
		t,
		part2 == part2_expected,
		fmt.tprintf("Expected %v, got %v", part2_expected, part2),
	)
}

setup_day19 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	options.input = get_input(DAY)
	return nil
}

bench_day19 :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> time.Benchmark_Error {
	for _ in 0 ..< options.rounds {
		_, _ = day19(string(options.input))
	}
	options.count = options.rounds
	return nil
}
