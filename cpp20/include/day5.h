#pragma once

#include <vector>
#include <string>

#include "day.h"

class Day5 : public Day
{
  private:
    std::vector<int> read_input(std::string filename);

  public:
    Day5();
    ~Day5();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
