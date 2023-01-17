from time import perf_counter

with open('08.txt', 'r') as file:
    inp = [[int(h) for h in l.strip()] for l in file.readlines()]

t1_start = perf_counter()

N = len(inp)
V = [(0,1),(0,-1),(1,0),(-1,0)]

# Part 1
coords = [(r,c) for r in range(1,N-1) for c in range(1,N-1)]
visible = set()
sol_a = 4*(N-1)
for r,c in coords:
    for (rr,cc),(dr,dc) in zip([(r,0),(r,N-1),(0,c),(N-1,c)], V):
        v = False
        while inp[rr][cc] < inp[r][c]:
            rr += dr
            cc += dc
            if rr == r and cc == c:
                sol_a += 1
                visible.add((r,c))
                v = True
                break
        if v: break

# Part 2
sol_b = 0
for r in range(N):
    for c in range(N):
        cur_ss = 1
        for dr,dc in V:
            dist = 0
            rr,cc = r,c
            while ((0 <= rr+dr < N) and (0 <= cc+dc < N)):
                rr += dr
                cc += dc
                dist += 1
                if inp[rr][cc] >= inp[r][c]:
                    break
            cur_ss *= dist
        sol_b = max(sol_b, cur_ss)

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)