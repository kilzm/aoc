from time import perf_counter
from typing import List
from dataclasses import dataclass
from copy import deepcopy
import re

with open('11.txt', 'r') as file:
    lines = file.read()

@dataclass
class Monkey:
    items: List[int]
    operator: str
    value: str
    div: int
    to_t: int
    to_f: int
    insp: int = 0

t1_start = perf_counter()

M = lines.split('\n\n')
mlines = [m.split('\n') for m in M]
monkeys = []

for monkey in mlines:
    monkeys.append(Monkey(
        [int(x) for x in re.findall(r'\d+', monkey[1])],
        '+' if '+' in monkey[2] else '*',
        monkey[2].split()[-1],
        int(monkey[3].split()[-1]),
        int(monkey[4].split()[-1]),
        int(monkey[5].split()[-1])
    ))

monkeys_b = deepcopy(monkeys)

R = 20
for i in range(R):
    for m in monkeys:
        while m.items:
            m.insp += 1
            worry = m.items.pop(0)
            if m.value.isdigit():
                worry = worry + int(m.value) if m.operator == '+' else worry * int(m.value)
            else:
                worry = worry**2
            worry //= 3
            monkeys[m.to_t].items.append(worry) if worry%m.div==0 else monkeys[m.to_f].items.append(worry)

insps = sorted([m.insp for m in monkeys])
sol_a = insps[-1]*insps[-2]

N, R = 1, 10000
for m in monkeys_b: N *= m.div

for i in range(R):
    for m in monkeys_b:
        while m.items:
            m.insp += 1
            worry = m.items.pop(0)
            if m.value.isdigit():
                worry = worry + int(m.value) if m.operator == '+' else (worry*int(m.value))
            else:
                worry = (worry)**2
            if worry%m.div==0:
                monkeys_b[m.to_t].items.append(worry%N)
            else:
                monkeys_b[m.to_f].items.append(worry%N)



insps_b = sorted([m.insp for m in monkeys_b])
sol_b = insps_b[-1]*insps_b[-2]

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)