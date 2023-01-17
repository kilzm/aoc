from time import perf_counter
from functools import cmp_to_key

with open('13.txt', 'r') as file:
    inp = file.read()

t1_start = perf_counter()

def compair(p1 : list, p2 : list) -> bool:
    if len(p2) == 0: return 1
    if len(p1) == 0: return -1
    x1,x2 = p1[0], p2[0]
    if type(x1) == type(x2) == int:
        if x1 == x2:
            return compair(p1[1:],p2[1:])
        elif x1 < x2: return -1
        else: return 1
    elif type(x1) == type(x2) == list:
        if len(x1) != len(x2):
            return compair(x1,x2)
        else:
            return compair(x1+p1[1:],x2+p2[1:])
    elif type(x1) == int:
        return compair([x1],x2)
    elif type(x2) == int:
        return compair(x1,[x2])
    else:
        assert False

sol_a = 0
pairs = inp.split('\n\n')
for i,pair in enumerate(pairs):
    p1,p2 = pair.split('\n')
    if compair(eval(p1),eval(p2)) == -1:
        sol_a += i+1

all_packets = [[[2]],[[6]]] + [eval(x) for x in inp.split('\n') if x != '']
all_packets.sort(key=cmp_to_key(compair))
sol_b = 1
for i,p in enumerate(all_packets):
    if p == [[2]] or p == [[6]]:
        sol_b*=i+1

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)