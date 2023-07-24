#include <vector>
#include <string>
#include <algorithm>
#include <unordered_set>

#include "day1.h"
#include "file_util.h"

Day1::Day1():Day(0) {}
Day1::~Day1() {}

std::vector<long> Day1::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<long> numbers;
    for (auto line : lines) {
        numbers.push_back(std::stoi(line));
    }
    return numbers;
}

std::string Day1::part1(std::string filename)
{
    std::vector<long> numbers = read_input(filename);
    for (long number : numbers) {
        long target = 2020 - number;
        auto it = find(numbers.begin(), numbers.end(), target);
        if (it != numbers.end()) {
            return std::to_string(number * target);
        }
    }
    return "error: no possible combination found";
}

std::string Day1::part2(std::string filename)
{
    std::vector<long> numbers = read_input(filename);
    std::unordered_set<long> set(numbers.begin(), numbers.end());
    for (long number : numbers) {
        for (long number2 : numbers) {
            if (number == number2) continue;
            long target = 2020 - number - number2;
            if (set.find(target) != set.end())
                return std::to_string(number * number2 * target);
        }
    }
    return "error: no possible combination found";
}