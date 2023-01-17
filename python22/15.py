from time import perf_counter
#from parse import parse
from collections import defaultdict
import re

with open('15.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

D, L = {}, defaultdict(list)
for l in lines:
    sx,sy,bx,by = map(int, re.findall('-?\d+\.?\d*',l))
    d_man = abs(sx-bx)+abs(sy-by)
    D[(sx,sy)] = bx,by
    L[sy].append((sx-d_man,sx+d_man+1))
    for i in range(1,d_man):
        cur_range = (sx-(d_man-i),sx+(d_man-i)+1)
        L[sy+i].append(cur_range)
        L[sy-i].append(cur_range)

LINE = 2_000_000

def merge_interval(intervals):
    intervals.sort(key=lambda x: x[0])
    merged = []
    for l,u in intervals:
        if not merged or merged[-1][1] < l:
            merged.append((l,u))
        else:
            merged[-1] = merged[-1][0], max(merged[-1][1], u)
    return merged

sol_a = sum((r_max-r_min) for r_min,r_max in merge_interval(L[LINE]))
for _,by in set(D.values()):
    if by == LINE:
        sol_a -=1

MAX = 4_000_000
bc_y = -1
for i in range(MAX):
    if len(merge_interval(L[i])) > 1:
        bc_y = i
        break

assert bc_y != -1
bc_x = merge_interval(L[bc_y])[0][1]
sol_b = bc_x*MAX+bc_y

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)