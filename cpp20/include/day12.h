#pragma once

#include <vector>
#include <string>

#include "day.h"

class Day12 : public Day
{
  private:
    std::vector<std::pair<char, int>> read_input(std::string filename);

  public:
    Day12();
    ~Day12();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
