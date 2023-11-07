#include <vector>
#include <string>
#include <algorithm>
#include <unordered_set>

#include "day6.h"
#include "file_util.h"

Day6::Day6():Day(5) {};
Day6::~Day6() {}

std::vector<Group> Day6::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    lines.push_back("");

    std::vector<Group> groups;
    auto group_begin = lines.begin();
    decltype(group_begin) group_end;
    for (auto it = lines.begin(); it != lines.end(); ++it) {
        if ((*it).empty()) {
            group_end = it;
            Group group(group_begin, group_end);
            groups.push_back(group);
            group_begin = group_end + 1;
        }
    }
    return groups;
}


std::string Day6::part1(std::string filename)
{
    std::vector<Group> groups = read_input(filename);
    int sum = 0;
    for (const auto& group : groups) {
        std::vector<int> table(26, 0);
        for (const auto& person : group) {
            for (const auto c : person) {
                table[c - 'a'] += 1;
            }
        }
        for (auto n : table) {
            if (n > 0) sum++;
        }
    }
    return std::to_string(sum);
}


std::string Day6::part2(std::string filename)
{
    std::vector<Group> groups = read_input(filename);
    int sum = 0;
    for (const auto& group : groups) {
        std::vector<int> table(26, 0);
        for (const auto& person : group) {
            for (const auto c : person) {
                table[c - 'a'] += 1;
            }
        }
        for (std::size_t n : table) {
            if (n == group.size()) sum++;
        }
    }
    return std::to_string(sum);
};
