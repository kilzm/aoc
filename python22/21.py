from time import perf_counter

with open('21.txt', 'r') as file:
    lines = [l.strip() for l in file.readlines()]

t1_start = perf_counter()

L = list(filter(lambda l: len(l) <= 10, lines))
D = list(filter(lambda l: len(l) >= 16, lines))
assert len(L) + len(D) == len(lines)

M,Q = {},[]
for l in L:
    n,v = l.split(': ')
    M[n] = int(v)

for d in D:
    n,x,o,y = d.split(' ')
    if o == '/': o = '//'
    Q.append((n[:-1],x,o,y))
O = Q[:]

while Q:
    n,x,o,y = Q.pop(0)
    if x not in M or y not in M:
        Q.append((n,x,o,y))
        continue
    M[n] = eval(f"{M[x]} {o} {M[y]}")

humn = ['humn']
foundroot = False
while not foundroot:
    for (n,x,_,y) in O:
        if x in humn or y in humn:
            if n == 'root':
                humn.append(n)
                foundroot = True
                break
            if n not in humn:
                humn.append(n)

S = {n: (x,(o if o != '/' else '//'),y) if n != 'root' else (x,'=',y) for (n,x,o,y) in O if n in humn}
Mb = {k: v for k,v in M.items() if k not in humn}
opp = {'+': '-', '-': '+', '*': '//', '//': '*'}

for n in reversed(humn[1:]):
    x,o,y = S[n]
    var_left = True
    assert y in Mb or x in Mb
    if y not in Mb:
        x,y = y,x
        var_left = False
    if o in '*+':
        Mb[x] = eval(f"{Mb[n]} {opp[o]} {Mb[y]}")
    elif o in '-//':
        o = opp[o] if var_left else o
        Mb[x] = eval(f"Mb[y] {o} Mb[n]")
    else: exec(f"Mb[x] {o} Mb[y]")

sol_a = M['root']
sol_b = Mb['humn']

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)