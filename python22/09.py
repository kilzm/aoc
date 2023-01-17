from time import perf_counter

with open('09.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

V = {'R': (0,1), 'D': (-1,0), 'L': (0,-1), 'U': (1,0)}

def touching(head, tail):
    return abs(head[0]-tail[0]) <= 1 and abs(head[1]-tail[1]) <= 1

def sign(n):
    if n > 0: return 1
    elif n < 0: return -1
    return 0

x1, x2 = 0,0
path = [(x1,x2)]
for l in lines:
    d, a = l.split()
    for i in range(int(a)):
        x1,x2 = x1+V[d][0], x2+V[d][1]
        path.append((x1,x2))

def solve(path):
    cur = (0,0)
    npath = []
    for head in path:
        if not touching(head, cur):
            dr = sign(head[0]-cur[0])
            dc = sign(head[1]-cur[1])
            cur = cur[0]+dr, cur[1]+dc
        npath.append(cur)
    return npath

N = 10
for i in range(N-1):
    if i == 1:
        sol_a = len(set(path))
    path = solve(path)

sol_b = len(set(path))

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)