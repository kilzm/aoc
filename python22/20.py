from time import perf_counter

with open('20.txt', 'r') as file:
    nums = [int(num) for num in file.readlines()]

t1_start = perf_counter()

LEN = len(nums)

def solve(N: list, it: int):
    N = list(enumerate(N))
    for _ in range(it):
        for i in range(LEN):
            for j in range(LEN):
                if N[j][0] == i: break
            ni = (j+N[j][1])%(LEN-1)
            if ni > j:
                N = N[:j] + N[j+1:ni+1] + [N[j]] + N[ni+1:]
            else:
                N = N[:ni] + [N[j]] + N[ni:j] + N[j+1:]
    D = [v for _,v in N]
    start = D.index(0)
    return sum([D[(start+(i+1)*1000)%LEN] for i in range(3)])

KEY = 811589153
sol_a = solve(nums, 1)
sol_b = solve([n*KEY for n in nums], 10)

t1_stop = perf_counter()

print('part a:', sol_a)
print('part b:', sol_b)
print('time:', t1_stop-t1_start)