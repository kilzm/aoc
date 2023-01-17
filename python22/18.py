from time import perf_counter
from collections import defaultdict

with open('18.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

V = [(1,0,0),(-1,0,0),(0,1,0),(0,-1,0),(0,0,1),(0,0,-1)]
max_x,max_y,max_z = 0,0,0
D = defaultdict(bool)
cubes = []
for cube in lines:
    x,y,z = (map(int, cube.split(',')))
    D[x,y,z] = True
    cubes.append((x,y,z))
    max_x,max_y,max_z = max(max_x, x),  max(max_y, y),  max(max_z, z)

max_t = max(max_x, max_y, max_z)

def blocked(cubes, D):
    S = 0
    for x,y,z in cubes:
        S += sum([D[x+1,y,z], D[x-1,y,z], D[x,y+1,z], D[x,y-1,z], D[x,y,z+1], D[x,y,z-1]])
    return S

sol_a = len(cubes)*6-blocked(cubes, D)

def flood_fill(D, point=(-1,-1,-1)):
    W = set()
    stack = [point]
    while stack:
        point = stack.pop()
        if min(point) < -1 or max(point) > max_t+1 or D[point] == 1 or point in W:
            continue
        W.add(point)
        x,y,z = point
        for dx,dy,dz in V:
            stack.append((x+dx,y+dy,z+dz))
    return W

W = flood_fill(D)
F = defaultdict(int)
for x in range(-1,max_x+1):
    for y in range(-1,max_y+1):
        for z in range(-1,max_z+1):
            if (x,y,z) not in W and (x,y,z) not in cubes:
                cubes.append((x,y,z))
                D[(x,y,z)] = 1

sol_b = len(cubes)*6-blocked(cubes, D)

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)