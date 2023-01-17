from time import perf_counter

with open('25.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

D = {'2': 2, '1': 1, '0': 0, '-': -1, '=': -2}

def convert(snafu):
    decimal_val = 0
    for i,digit in enumerate(reversed(snafu)):
        digit = D[digit]
        decimal_val += digit*5**i
    return decimal_val

S = sum([convert(snafu.strip()) for snafu in lines])
power = 0
while 5**power < S: power += 1

sol_a = ''
for p in range(power-1, -1, -1):
    dif = 1e20
    digit = ''
    for d in list("210-="):
        cur_dif = abs(S-D[d]*5**p)
        if cur_dif < dif:
            digit = d
            dif = cur_dif
    S -= D[digit]*5**p
    sol_a += digit

t1_stop = perf_counter()

print('part a:', sol_a)
print('time:', t1_stop-t1_start)