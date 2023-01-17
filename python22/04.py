from time import perf_counter

with open('04.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

cont  = lambda e: e[1][0] >= e[0][0] and e[1][1] <= e[0][1] or e[0][0] >= e[1][0] and e[0][1] <= e[1][1]
overl = lambda e: e[1][0] <= e[0][1] <= e[1][1] or e[0][0] <= e[1][1] <= e[0][1]
parsed = [[[int(n) for n in x.split('-')] for x in l.strip().split(',')] for l in lines]
sol_a, sol_b = sum(map(cont, parsed)), sum(map(overl, parsed))

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)