#include <vector>
#include <string>
#include <algorithm>

#include "day2.h"
#include "file_util.h"


Day2::Day2():Day(1) {}
Day2::~Day2() {}

std::vector<policy> Day2::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<policy> policies;

    auto parse_policy = [](std::string s) {
        size_t pos_hyp = s.find('-');
        size_t pos_spc = s.find(' ');
        policy p {
            .lower = std::stoi(s.substr(0, pos_hyp)),
            .upper = std::stoi(s.substr(pos_hyp + 1, pos_spc)),
            .character = s[pos_spc + 1],
            .password = s.substr(pos_spc + 4),
        };
        return p;
    };

    for (std::string line : lines) {
        policy p = parse_policy(line);
        policies.push_back(p);
    }
    return policies;
}

std::string Day2::part1(std::string filename)
{
    std::vector<policy> policies = read_input(filename);
    int valid_count = 0;
    for (const auto& p : policies) {
        int count = std::count(p.password.begin(), p.password.end(), p.character);
        if (p.lower <= count && count <= p.upper) {
            ++valid_count;
        }
    }
    return std::to_string(valid_count);
}

std::string Day2::part2(std::string filename)
{
    std::vector<policy> policies = read_input(filename);
    int valid_count = 0;
    for (const auto& p : policies) {
        if ((p.password[p.lower - 1] == p.character) != (p.password[p.upper - 1] == p.character)) {
            ++valid_count;
        }
    }
    return std::to_string(valid_count);
}
