#include <vector>
#include <iostream>

#include "day3.h"
#include "file_util.h"

Day3::Day3():Day(2) {}
Day3::~Day3() {}

std::vector<std::vector<char>> Day3::read_input(std::string filename)
{
    FileUtil fileutil;
    return fileutil.read_matrix(filename);
}


std::string Day3::part1(std::string filename)
{
    const std::vector<std::vector<char>> forest = read_input(filename);
    const std::size_t col_count = forest[0].size();
    std::size_t row = 0, col = 0;
    std::size_t tree_count = 0;
    Slope slope = {.x = 3, .y = 1};
    while (row != forest.size() - 1) {
        row += slope.y;
        col = (col + slope.x) % col_count;
        if (forest[row][col] == '#') {
            ++tree_count;
        }
    }
    return std::to_string(tree_count);
}


std::string Day3::part2(std::string filename)
{
    const std::vector<std::vector<char>> forest = read_input(filename);
    const std::size_t col_count = forest[0].size();
    const std::vector<Slope> slopes = {
        {.x = 1, .y = 1},
        {.x = 3, .y = 1},
        {.x = 5, .y = 1},
        {.x = 7, .y = 1},
        {.x = 1, .y = 2},
    };
    std::size_t result = 1;
    for (auto slope : slopes) {
        std::size_t row = 0, col = 0;
        std::size_t tree_count = 0;
        while (row != forest.size() - 1) {
            row += slope.y;
            col = (col + slope.x) % col_count;
            if (forest[row][col] == '#') {
                ++tree_count;
            }
        }
        result *= tree_count;
    }
    return std::to_string(result);
}