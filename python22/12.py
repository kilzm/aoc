from time import perf_counter

with open('12.txt', 'r') as file:
    grid = [list(r.strip()) for r in file.readlines()]

t1_start = perf_counter()

def height(r, c):
    if grid[r][c] == 'S':
        return 1
    if grid[r][c] == 'E':
        return 26
    else:
        return ord(grid[r][c])-96

def solve(starts, end, grid):
    R,C = len(grid), len(grid[0])
    queue,seen = [], set()
    for start in starts:
        queue.append((0,start))
    while queue:
        cost,(r,c) = queue.pop(0)
        if (r,c) in seen: continue
        seen.add((r,c))
        if (r,c) == end: return cost
        for dr,dc in [(0,1),(-1,0),(1,0),(0,-1)]:
            rr = r+dr
            cc = c+dc
            if 0 <= rr < R and 0 <= cc < C and height(rr,cc)-height(r,c)<=1:
                queue.append((cost+1,(rr,cc)))

R,C = len(grid), len(grid[0])
poss_starts = []
for (r,c) in [(r,c) for r in range(R) for c in range(C)]:
    if grid[r][c] == 'S':
        start = (r,c)
        poss_starts.append(start)
    elif grid[r][c] == 'a': poss_starts.append((r,c))
    elif grid[r][c] == 'E': end = (r,c)

sol_a = solve([start],end,grid)
sol_b = solve(poss_starts,end,grid)

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)