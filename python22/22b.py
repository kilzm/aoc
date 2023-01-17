from time import perf_counter
import re

with open('22.txt', 'r') as file:
    inp = file.read()

t1_start = perf_counter()

field,moves = inp.split('\n\n')
field = field.split('\n')
WIDTH, HEIGHT, SIDE = max([len(l) for l in field]), len(field), 50
field = [list(s.ljust(WIDTH)) for s in field]
moves = [int(m) if m.isdigit() else m for m in re.findall(r"\d+|\D", moves)]

L = []
for y in range(HEIGHT//SIDE):
    for x in range(WIDTH//SIDE):
        L.append([rows[x*SIDE:(x+1)*SIDE] for rows in field[y*SIDE:(y+1)*SIDE]])

L = [g for g in L if g[0][0] != ' ']

def turn_vec(v, turn):
    if v == (0,1) and turn == 'R' or v == (0,-1) and turn == 'L':
        return (1,0)
    elif v == (1,0) and turn == 'R' or v == (-1,0) and turn == 'L':
        return (0,-1)
    elif v == (0,-1) and turn == 'R' or v == (0,1) and turn == 'L':
        return (-1,0)
    elif v == (-1,0) and turn == 'R' or v == (1,0) and turn == 'L':
        return (0,1)

def new_coords(r, c, d_prev, d_next):
    nr,nc = r,c
    if d_prev == 0:
        nr,nc = r,0
    elif d_prev == 1:
        nr,nc = 0,c
    elif d_prev == 2:
        nr,nc = r,SIDE-1
    elif d_prev == 3:
        nr,nc = SIDE-1,c
    rots = (d_prev-d_next)%4
    for _ in range(rots):
        nr,nc = SIDE-nc-1, nr
    return nr,nc


V = [(0,1),(1,0),(0,-1),(-1,0)]

# tuple (face, direction) for directions R,D,L,U
M = [
    [(1,0),(2,1),(3,0),(5,0)], # 0
    [(4,2),(2,2),(0,2),(5,3)], # 1
    [(1,3),(4,1),(3,1),(0,3)], # 2
    [(4,0),(5,1),(0,0),(2,0)], # 3
    [(1,2),(5,2),(3,2),(2,3)], # 4
    [(4,3),(1,1),(0,1),(3,3)], # 5
    ]

# row,col,dir,face,movevec
r,c,d,f,v = 0,0,0,0,(0,1)

for m in moves:
    if type(m) == int:
        dr,dc = v
        while m > 0:
            dr,dc = v
            rr,cc = (r+dr),(c+dc)
            if not (0 <= rr < SIDE) or not (0 <= cc < SIDE):
                d_prev = V.index(v)
                f_next = M[f][d_prev][0]
                d_next = M[f][d_prev][1]
                rr,cc = new_coords(rr-dr,cc-dc,d_prev,d_next)
                if L[f_next][rr][cc] == '#':
                    break
                else:
                    f = f_next
                    v = V[d_next]
            if L[f][rr][cc] == '#':
                break
            r,c = rr,cc
            m -= 1
    else:
        v = turn_vec(v,m)

offset = [(0,SIDE),(0,2*SIDE),(SIDE,SIDE),(2*SIDE,0),(2*SIDE,SIDE),(3*SIDE,0)]

ro,co = offset[f]
sol_b = 1000*(r+ro+1)+4*(c+co+1)+V.index(v)

t1_stop = perf_counter()

print('part b:', sol_b)
print('time:', t1_stop-t1_start)