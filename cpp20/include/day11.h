#pragma once

#include <vector>
#include <string>

#include "day.h"

class Day11 : public Day
{
  private:
    std::vector<std::string> read_input(std::string filename);

  public:
    Day11();
    ~Day11();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
