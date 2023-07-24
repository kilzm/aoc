#pragma once

#include <vector>

#include "day.h"

class Day1 : public Day
{
  private:
    std::vector<long> read_input(std::string filename);

  public:
    Day1();
    ~Day1();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
