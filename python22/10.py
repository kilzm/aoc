from time import perf_counter

with open('10.txt', 'r') as file:
    lines = file.readlines()

t1_start = perf_counter()

sol_a = 0
i_o, i_c, x = 0, 0, 1
snd_add = False
pixels = []
while i_o < len(lines):
    l = lines[i_o].split()
    pos = i_c%40
    if pos in [x-1,x,x+1]:
        pixels.append('##')
    else:
        pixels.append('..')
    i_c += 1
    if i_c in [20+i*40 for i in range(6)]:
        sol_a += i_c*x
    if l[0] == 'addx':
        if snd_add:
            x += int(l[1])
            i_o += 1
        snd_add = not snd_add
    else:
        i_o += 1

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:')
for i in range(6):
    print(''.join(pixels[i*40:(i+1)*40]))
print('time:', t1_stop-t1_start)