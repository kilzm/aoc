from time import perf_counter

with open('01.txt', 'r') as file:
    lines = file.read()

t1_start = perf_counter()

ranking = sorted([sum([int(x) for x in l.split("\n")]) for l in lines.split("\n\n")], reverse=True)
sol_a, sol_b = ranking[0], sum(ranking[:3])

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)