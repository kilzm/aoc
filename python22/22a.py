from time import perf_counter
import re

with open('22.txt', 'r') as file:
    inp = file.read()

t1_start = perf_counter()

field,moves = inp.split('\n\n')
field = field.split('\n')
WIDTH, HEIGHT = max([len(l) for l in field]), len(field)
field = [list(s.ljust(WIDTH)) for s in field]
#print_grid(field)
moves = [int(m) if m.isdigit() else m for m in re.findall(r"\d+|\D", moves)]

def turn_dir(d, turn):
    return (d+(1 if turn == 'R' else -1))%4

V = [(0,1),(1,0),(0,-1),(-1,0)]

r,c,d = 0,0,0
while field[r][c] != '.': c += 1

for m in moves:
    if type(m) == int:
        # walk
        dr,dc = V[d]
        while m > 0:
            rr,cc = (r+dr)%HEIGHT,(c+dc)%WIDTH
            if field[rr][cc] == ' ':
                while field[rr][cc] == ' ':
                    rr,cc = (rr+dr)%HEIGHT,(cc+dc)%WIDTH
            if field[rr][cc] == '#':
                break
            r,c = rr,cc
            #print(r,c)
            m -= 1
    else:
        d = turn_dir(d, m)

sol_a = 1000*(r+1)+4*(c+1)+d

r,c,d = 0,0,0
while field[r][c] != '.': c += 1



t1_stop = perf_counter()

print('part a:', sol_a)
print('time:', t1_stop-t1_start)