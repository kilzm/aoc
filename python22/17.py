from time import perf_counter

with open('17.txt', 'r') as file:
    inp = file.read().strip()

t1_start = perf_counter()

LEN = len(inp)
# coordinates of rock squares relative to bottom left
D = { 0: [(0,0),(1,0),(2,0),(3,0)],
      1: [(1,0),(0,1),(1,1),(2,1),(1,2)],
      2: [(0,0),(1,0),(2,0),(2,1),(2,2)],
      3: [(0,0),(0,1),(0,2),(0,3)],
      4: [(0,0),(0,1),(1,0),(1,1)] }

def print_grid(grid):
    for l in reversed(grid):
        print(' '.join(l))
    print()

def add(v, u):
    return tuple(map(sum, zip(v, u)))

def is_valid(rock, B):
    for x,_ in rock:
        if x < 0 or x >= 7: return False
    for x,y in rock:
        if (x,y) in B or y < 0: return False
    return True

def move_rock(rock, v, B):
    moved = [add(r,v) for r in rock]
    return moved if is_valid(moved, B) else rock

def update_height(rock, H):
    for x,y in rock:
        if y+1 > H[x]: H[x] = y+1

grid = [['.' for _ in range(7)] for _ in range(20)]

def ground_sig(low,B):
    return frozenset([(x,y-low) for x,y in B if y>=low])

def solve(n):
    seen = {}
    H = [0 for _ in range(7)] # highest y for each x
    B = set() # blocked
    j, i = 0, 0
    added = 0
    while i < n:
        rock = D[i%len(D)]
        offset = 2,max(H)+3
        rock = move_rock(rock, offset, B)
        while True:
            # horizontal move
            move = (1,0) if inp[j%LEN] == '>' else (-1,0)
            j += 1
            rock = move_rock(rock, move, B)
            # vertical move
            moved = move_rock(rock, (0,-1), B)
            if rock != moved:
                rock = moved
            else:
                update_height(rock, H)
                break
        B.update(rock)
        top = max(H)
        sig = (ground_sig(min(H), B), j%LEN, i%5)
        if sig in seen and i >= 2022:
            oi, otop = seen[sig]
            dy = top-otop
            di = i - oi
            amt = (n-i)//di
            added += dy*amt
            i += amt*di
        seen[sig] = i,top
        i += 1
    return added+max(H)

sol_a = solve(2022)
sol_b = solve(1_000_000_000_000)

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)