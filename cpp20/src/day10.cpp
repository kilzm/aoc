#include <vector>
#include <string>
#include <algorithm>
#include <ranges>

#include "day10.h"
#include "file_util.h"

Day10::Day10():Day(9) {}
Day10::~Day10() {}

std::vector<unsigned long> Day10::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<unsigned long> adapters;

    for(const auto& line : lines) {
        adapters.push_back(std::stoul(line));
    }

    return adapters;
}


std::string Day10::part1(std::string filename)
{
    std::vector<unsigned long> adapters = read_input(filename);
    std::ranges::sort(adapters);
    adapters.insert(adapters.begin(), 0);
    adapters.push_back(adapters.back() + 3);

    size_t diffs_of_1 = 0;
    size_t diffs_of_3 = 0;
    auto cur = adapters.begin();
    for (auto next = cur + 1; next != adapters.end(); ++next) {
        auto diff = *next - *cur;
        if (diff == 1) ++diffs_of_1;
        else if (diff == 3) ++diffs_of_3;
        cur = next;
    }

    return std::to_string(diffs_of_1 * diffs_of_3);
}


std::string Day10::part2(std::string filename)
{
    std::vector<unsigned long> adapters = read_input(filename);
    std::ranges::sort(adapters);
    adapters.insert(adapters.begin(), 0);
    adapters.push_back(adapters.back() + 3);

    auto tribonacci = [](size_t n) -> size_t {
        if (n == 0) return 0;
        if (n <= 2) return 1;
        size_t t0 = 0, t1 = 1, t2 = 1, tn;
        for (size_t i = 3; i <= n; ++i) {
            tn = t0 + t1 + t2;
            t0 = t1;
            t1 = t2;
            t2 = tn;
        }
        return tn;
    };
    
    size_t arrangements = 1;
    size_t consecutive = 1;
    auto cur = adapters.begin();

    for (auto next = cur + 1; next != adapters.end(); ++next) {
        auto adpt_next = *next, adpt_cur = *cur;
        cur = next;
        if (adpt_next - adpt_cur == 1) {
            ++consecutive;
            continue;
        }
        arrangements *= tribonacci(consecutive);
        consecutive = 1;
    }

    return std::to_string(arrangements);
}
