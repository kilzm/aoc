from time import perf_counter
from collections import defaultdict
import sys

with open('23.txt', 'r') as file:
    inp = [list(l.strip()) for l in file.readlines()]

t1_start = perf_counter()

HEIGHT, WIDTH = len(inp), len(inp[0])

def get_adjacent(D, r, c):
    A = {}
    for dr in [-1,0,1]:
        for dc in [-1,0,1]:
            if dr == dc == 0:
                continue
            A[(dr,dc)] = (r+dr,c+dc) not in D
    return A

D = set() # for tracking the elves positions
for r in range(HEIGHT):
    for c in range(WIDTH):
        if inp[r][c] == '#': D.add((r,c))


ALL   = [(-1,-1),(-1,0),(-1,1),(0,1),(1,-1),(1,0),(1,1),(0,-1)]
NORTH = [(-1,-1),(-1,0),(-1,1)]
SOUTH = [(1,-1),(1,0),(1,1)]
WEST  = [(-1,-1),(0,-1),(1,-1)]
EAST  = [(1,1),(0,1),(-1,1)]

order = [((-1,0), NORTH),((1,0), SOUTH),((0,-1), WEST),((0,1), EAST)]

i, moved = 0, True
while moved:
    moved = False
    M = {} # for tracking the move suggestions
    for (r,c) in D:
        A = get_adjacent(D,r,c)
        for (ddr,ddc),pos_to_check in order:
            if all([A[v] for v in pos_to_check]):
                dr,dc = ddr,ddc
                break
        else:
            dr,dc = 0,0
        if all([A[v] for v in ALL]) == 1:
            dr,dc = 0,0
        M[(r,c)] = (r+dr,c+dc)

    order.append(order.pop(0))
    L = list(M.values())
    for (r,c),(rr,cc) in M.items():
        if L.count((rr,cc)) == 1:
            if (r,c) != (rr,cc):
                moved = True
                D.add((rr,cc))
                D.remove((r,c))
    i += 1

    if i == 10:
        r_min, r_max = sys.maxsize, -sys.maxsize
        c_min, c_max = sys.maxsize, -sys.maxsize

        for (r,c) in D:
            r_min, r_max = min(r_min, r), max(r_max, r)
            c_min, c_max = min(c_min, c), max(c_max, c)

        sol_a = 0
        for r in range(r_min,r_max+1):
            for c in range(c_min, c_max+1):
                if (r,c) not in D: sol_a += 1
        print('part a:', sol_a)

sol_b = i
t1_stop = perf_counter()

print('part b:', sol_b)
print('time:', t1_stop-t1_start)