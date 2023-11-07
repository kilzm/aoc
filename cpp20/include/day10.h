#pragma once

#include <vector>
#include <string>

#include "day.h"

class Day10 : public Day
{
  private:
    std::vector<unsigned long> read_input(std::string filename);

  public:
    Day10();
    ~Day10();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
