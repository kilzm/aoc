from time import perf_counter
from collections import defaultdict

with open('07.txt', 'r') as file:
    lines = [l.strip() for l in file.readlines()]

t1_start = perf_counter()

S = defaultdict(int)
path = []
for l in lines:
    cmd = l.split()
    if cmd[0] == '$': # terminal command
        if cmd[1] == 'ls': continue
        else:
            if cmd[2] == '..': path.pop()
            else:
                path.append(cmd[2])
    elif cmd[0].isnumeric(): # file size
        s = int(cmd[0])
        for i in range(len(path)):
            S['/'.join(path[:i+1])] += s
    else: continue

sol_a = 0
sol_b = S['/']
min_s = sol_b - 40_000_000

for v in S.values():
    if v < 100_000: sol_a += v
    if min_s <= v <= sol_b: sol_b = v

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)