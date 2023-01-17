from time import perf_counter
from collections import defaultdict

with open('14.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

D = defaultdict(lambda: '.')

for l in lines:
    points = []
    for point in l.split(' -> '):
        c,r = point.split(',')
        points.append((int(c),int(r)))
    for i in range(len(points)-1):
        (fc,fr),(tc,tr) = points[i:i+2]
        D[(fc,fr)] = '#'
        dc,dr = tc-fc,tr-fr
        if dr == 0 and dc != 0:
            for j in range(abs(dc)):
                if dc > 0: D[(fc+j,fr)] = '#'
                else: D[(fc-j,fr)] = '#'
        elif dr != 0 and dc == 0:
            for j in range(abs(dr)):
                if dr > 0: D[(fc,fr+j)] = '#'
                else: D[(fc,fr-j)] = '#'
        D[(tc,tr)] = '#'

abyss = max([p[1] for p in D.keys()])
ground = abyss + 2

in_abyss = False
sol_a,sol_b = 0,0

while D[500,0] != 'o':
    sc,sr = 500,0
    while (D[(sc-1,sr+1)] == '.' or D[(sc,sr+1)] == '.' or D[(sc+1,sr+1)] == '.') and sr < ground-1:
        if D[(sc,sr+1)] == '.': pass
        elif D[(sc-1,sr+1)] == '.': sc -= 1
        elif D[(sc+1,sr+1)] == '.': sc += 1
        sr += 1
    D[(sc,sr)] = 'o'
    if sr > abyss: in_abyss = True
    if not in_abyss:
        sol_a += 1
    sol_b += 1

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)