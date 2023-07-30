#pragma once

#include <vector>
#include <string>

#include "day.h"

typedef std::vector<std::string> Group;

class Day6 : public Day
{
  private:
    std::vector<Group> read_input(std::string filename);

  public:
    Day6();
    ~Day6();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
