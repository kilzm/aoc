#include <vector>
#include <string>
#include <algorithm>

#include "day5.h"
#include "file_util.h"

Day5::Day5():Day(4) {};
Day5::~Day5() {}


std::vector<int> Day5::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<int> seat_ids;

    auto convert = [](std::string num_s) {
        int id = 0, cur = 1;
        for (auto it = num_s.rbegin(); it != num_s.rend(); ++it) {
            if (*it == 'B' || *it == 'R') {
                id += cur;
            }
            cur *= 2;
        }
        return id;
    };

    for (const auto& line : lines) {
        int id = convert(line);
        seat_ids.push_back(id);
    }
    return seat_ids;
}


std::string Day5::part1(std::string filename)
{
    std::vector<int> seat_ids = read_input(filename);
    auto max = std::max_element(seat_ids.begin(), seat_ids.end());
    return std::to_string(*max);
}


std::string Day5::part2(std::string filename)
{
    std::vector<int> seat_ids = read_input(filename);
    std::sort(seat_ids.begin(), seat_ids.end());
    int min = seat_ids.front();
    for (auto id : seat_ids) {
        if (min != id) return std::to_string(min);
        min++;
    }
    return "error: no seat missing";
};
