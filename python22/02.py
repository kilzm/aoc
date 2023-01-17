from time import perf_counter

with open('02.txt', 'r') as file:
    lines = [x.split() for x in file.readlines()]

t1_start = perf_counter()

S = {0: 3, 1: 0, 2: 6}
D = {'A': 0, 'B': 1, 'C': 2, 'X': 0, 'Y': 1, 'Z': 2}
sol_a = sum([S[(D[op]-D[me])%3]+D[me]+1 for op,me in lines])
sol_b = sum([D[me]*3+(D[op]+D[me]-1)%3+1 for op,me in lines])

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)