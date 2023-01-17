from time import perf_counter

with open('06.txt', 'r') as file:
    inp = file.read()

t1_start = perf_counter()

def find_marker(inp : str, n: int):
    for i in range(0,len(inp)-n):
        if(len(set(inp[i:i+n])) == n):
            return i+n

t1_stop = perf_counter()

print('part a:', find_marker(inp, 4))
print('part b:', find_marker(inp, 14))
print('time:', t1_stop-t1_start)