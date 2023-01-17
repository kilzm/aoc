from time import perf_counter

with open('24.txt', 'r') as file:
    grid = [list(l.strip()) for l in file.readlines()]

t1_start = perf_counter()

HG, WD = len(grid), len(grid[0])

B = {'>': [], 'v': [], '<': [], '^': [], '#': []}
V = {'>': (0,1), 'v': (1,0), '<': (0,-1), '^': (-1,0)}

for r,row in enumerate(grid):
    for c,x in enumerate(row):
        if x in "<>^v#":
            B[x].append((r,c))

def pgrid(grid):
    for l in grid:
        print(''.join(l))

def move_bliz(B):
    for d, bl in B.items():
        if d == '#': continue
        dr,dc = V[d]
        for i in range(len(bl)):
            r,c = bl[i][0]-1,bl[i][1]-1
            bl[i] = (r+dr)%(HG-2)+1,(c+dc)%(WD-2)+1
    return B

def update(grid, B):
    for r in range(1,HG-1):
        for c in range(1,WD-1):
            for d, bl in B.items():
                if (r,c) in bl:
                    grid[r][c] = d
                    break
            else:
                grid[r][c] = '.'
    return grid

def get_moves(B, r, c):
    occ = B['>'] + B['<'] + B['v'] + B['^'] + B['#']
    moves = [] if (r,c) in occ else [(r,c)]
    for dr,dc in V.values():
        rr = r+dr
        cc = c+dc
        if 0 <= rr < HG and 0 <= cc < WD and (rr,cc) not in occ:
            moves.append((rr,cc))
    return moves

def solve(B):
    time  = 0
    R = [(0,1), (HG-1,WD-2)]
    p1 = False

    for i in range(3):
        start, goal = R[i%2], R[(i+1)%2]
        reached = {start}
        found = False
        while not found:
            B = move_bliz(B)
            n_reached = set()
            for (r,c) in reached:
                if (r,c) == goal:
                    if not p1:
                        sol_a = time
                        p1 = True
                    found = True
                n_reached.update(get_moves(B, r, c))
            reached = n_reached
            time += 1

    return sol_a, time-1

sol_a, sol_b = solve(B)

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)