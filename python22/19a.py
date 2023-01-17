from time import perf_counter
from math import ceil
import re

with open('19.txt', 'r') as file:
    inp = file.readlines()

t1_start = perf_counter()

# never more than 4 ore robots
def dfs(bp, max_spend, cache, time_left, bots, inv):
    if time_left == 0:
        return inv[3]

    key = tuple([time_left, *bots, *inv])
    if key in cache: return cache[key]

    max_geodes = inv[3] + bots[3] * time_left

    for btype, recipe in enumerate(bp):
        if btype != 3 and bots[btype] >= max_spend[btype]:
            continue

        wait = 0
        for rtype, ramt in recipe:
            if bots[rtype] == 0:
                break
            wait = max(wait, ceil((ramt - inv[rtype]) / bots[rtype]))
        else:
            time_left_ = time_left - wait - 1
            if time_left_ <= 0:
                continue
            bots_ = bots[:]
            inv_ = [owned+nbots*(wait+1) for owned,nbots in zip(inv,bots)]
            for rtype, ramt in recipe:
                inv_[rtype] -= ramt
            bots_[btype] += 1
            for i in range(3):
                inv_[i] = min(inv_[i], max_spend[i]*time_left_)
            max_geodes = max(max_geodes, dfs(bp, max_spend, cache, time_left_, bots_, inv_))

    cache[key] = max_geodes
    return max_geodes

sol_a = 0
for i,line in enumerate(inp):
    bp = []
    max_spend = [0,0,0]
    for section in line.split(": ")[1].split(". "):
        recipe = []
        for x,y in re.findall(r"(\d+) (\w+)", section):
            x = int(x)
            y = ["ore", "clay", "obsidian"].index(y)
            recipe.append((y,x))
            max_spend[y] = max(max_spend[y], x)
        bp.append(recipe)
    v = dfs(bp, max_spend, {}, 24, [1,0,0,0], [0,0,0,0])
    sol_a += (i+1)*v

t1_stop = perf_counter()

print('part a:', sol_a)
print('time:', t1_stop-t1_start)