#include <vector>
#include <string>

#include "day9.h"
#include "file_util.h"

Day9::Day9():Day(8) {}
Day9::~Day9() {}

std::vector<long> Day9::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<long> numbers;

    for (const auto& line : lines) {
        numbers.push_back(std::stol(line));
    }

    return numbers;
}

std::string Day9::part1(std::string filename)
{
    const int window_size = 25; // change for test input
    const std::vector<long> numbers = read_input(filename);
    
    auto twosum = [](auto beg, auto end, long number) {
        for (; beg != end; ++beg) {
            long target = number - *beg;
            for (auto it = beg; it != end; ++it) {
                if (*it == target) return true;
            }
        }
        return false;
    };

    auto wbeg = numbers.begin();
    auto wend = wbeg + window_size;

    long number;
    for (auto it = numbers.begin() + window_size; it != numbers.end(); ++it) {
        number = *it;
        if (!twosum(wbeg, wend, number)) break;
        ++wbeg; ++wend;
    }

    return std::to_string(number);
}


std::string Day9::part2(std::string filename)
{
    const std::vector<long> numbers = read_input(filename);
    const long invalid = std::stol(part1_result.value());

    auto wbeg = numbers.begin();
    auto wend = wbeg + 1;

    long sum = *wbeg + *wend;

    while (sum != invalid && wend != numbers.end() - 1) {
        if (sum < invalid) sum += *(++wend);
        else sum -= *(wbeg++);
    }

    long min = *wbeg, max = *wbeg;
    for (auto it = wbeg; it != wend; ++it) {
        if (*it < min) min = *it;
        else if (*it > max) max = *it;
    }

    return std::to_string(min + max);
}
