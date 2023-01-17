from time import perf_counter
from functools import lru_cache
from copy import copy
import sys

with open('16.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

G_ = {}
F = {}
O = set()
for l in lines:
    l = l.strip().replace(',','').replace(';','').replace('rate=','').split()
    G_[l[1]] = l[9:]
    F[l[1]] = int(l[4])

def shortest_paths(G: dict, valves: list, start: str):
    U = [v for v in G.keys()]
    C = {v: sys.maxsize for v in U}
    C[start] = 0
    while U:
        min_node = None
        for v in U:
            if min_node == None or C[v] < C[min_node]:
                min_node = v
            for nb in G[v]:
                n_d = C[v] + 1
                if n_d < C[nb]:
                    C[nb] = n_d
        U.remove(min_node)
    return {v: d for v,d in C.items() if v in valves}

start='AA'
valves = [v for v,p in F.items() if p > 0]

G = {}
G[start] = shortest_paths(G_, valves, start)
for v in valves:
    G[v] = shortest_paths(G_, valves, v)

def poss_paths(pos: str = 'AA', open_valves: list = [], time_left: int = 30):
    for v in valves:
        if v not in open_valves and G[pos][v] <= time_left:
            open_valves.append(v)
            for v in poss_paths(v, open_valves, time_left-G[pos][v]-1): yield v
            open_valves.pop()
    yield copy(open_valves)

def calc_pressure(path: list, time_left: int = 30):
    elapsed = 0
    p_acc = 0
    prev = 'AA'
    for v in path:
        elapsed += G[prev][v]+1
        p_acc += (time_left-elapsed)*F[v]
        prev = v
    return p_acc

sol_a = max([calc_pressure(path) for path in poss_paths()])

sol_b = 0
paths = list(poss_paths(time_left=26))

best_scores = {}
for path in paths:
    p = calc_pressure(path, time_left=26)
    h = tuple(sorted(path))
    best_scores[h] = max(best_scores.get(h, 0), p)

best_scores = list(best_scores.items())
sol_b = 0
for h_i in range(len(best_scores)):
    for e_i in range(h_i+1, len(best_scores)):
        h_opens, h_pressure = best_scores[h_i]
        e_opens, e_pressure = best_scores[e_i]

        if len(set(h_opens).intersection(e_opens)) == 0:
            sol_b = max(sol_b, h_pressure+e_pressure)


t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)