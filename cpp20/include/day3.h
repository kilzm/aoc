#pragma once

#include <vector>

#include "day.h"

struct Slope {
    std::size_t x, y;
};

class Day3 : public Day
{
  private:
    std::vector<std::vector<char>> read_input(std::string filename);

  public:
    Day3();
    ~Day3();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
