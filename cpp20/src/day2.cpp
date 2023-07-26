#include <vector>
#include <string>
#include <regex>
#include <algorithm>
#include <omp.h>

#include "day2.h"
#include "file_util.h"


Day2::Day2():Day(1) {}
Day2::~Day2() {}

std::vector<policy> Day2::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<policy> policies;
    const std::regex pattern(R"((\d+)-(\d+) ([a-z]): ([a-z]+))");
    for (std::string line : lines) {
        std::smatch matches;
        if (std::regex_search(line, matches, pattern)) {
            policy p {
                .lower = std::stoi(matches[1]),
                .upper = std::stoi(matches[2]),
                .character = matches[3].str()[0],
                .password = matches[4].str(),
            };
            policies.push_back(p);
        }
    }
    return policies;
}

std::string Day2::part1(std::string filename)
{
    std::vector<policy> policies = read_input(filename);
    int valid_count = 0;
    omp_set_num_threads(2);
    #pragma omp parallel for reduction(+:valid_count)
    for (auto it = policies.begin(); it < policies.end(); ++it) {
        auto p = *it;
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
    omp_set_num_threads(2);
    #pragma omp parallel for reduction(+:valid_count)
    for (auto it = policies.begin(); it < policies.end(); ++it) {
        auto p = *it;
        if ((p.password[p.lower - 1] == p.character) != (p.password[p.upper - 1] == p.character)) {
            ++valid_count;
        }
    }
    return std::to_string(valid_count);
}