from time import perf_counter
import re

with open('05.txt', 'r') as file:
    inp = file.read()

t1_start = perf_counter()

s, p = inp.split('\n\n')
s = reversed(s.split('\n')[:-1])
crates = [[l[i] for i in range(1,len(l),4)] for l in s]
s_a = [[] for _ in range(len(crates[0]))]
s_b = [[] for _ in range(len(crates[0]))]
for cs in crates:
    for i,c in enumerate(cs):
        if c != ' ':
            s_a[i].append(c)
            s_b[i].insert(0, c)

for move in p.split('\n'):
    q, f, t = map(int, re.findall(r'\d+', move))
    # Part 1
    for i in range(q):
        s_a[t-1].append(s_a[f-1].pop())
    # Part 2
    temp, s_b[f-1] = s_b[f-1][:q], s_b[f-1][q:]
    s_b[t-1][0:0] = temp

sol_a = ''.join([s[-1] for s in s_a])
sol_b = ''.join([s[0] for s in s_b])

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)