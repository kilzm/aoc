from time import perf_counter

with open('03.txt', 'r') as file:
    lines = [r.strip() for r in file.readlines()]

t1_start = perf_counter()

sum_prios = lambda l: sum(map(lambda x: ord(x)-(96 if x.islower() else 38), l))
sol_a = sum_prios([set(r[:len(r)//2]).intersection(set(r[len(r)//2:])).pop() for r in lines])
sol_b = sum_prios([set.intersection(*map(set, g)).pop() for g in zip(*(iter(lines),)*3)])

t1_stop = perf_counter()
print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)