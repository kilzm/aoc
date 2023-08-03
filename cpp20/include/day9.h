#pragma once

#include <vector>
#include <string>

#include "day.h"

class Day9 : public Day
{
  private:
    std::vector<long> read_input(std::string filename);

  public:
    Day9();
    ~Day9();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
