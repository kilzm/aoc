#pragma once

#include <vector>
#include <string>
#include <unordered_map>

#include "day.h"

class Day4 : public Day
{
  private:
    std::vector<std::unordered_map<std::string, std::string>> read_input(std::string filename);

  public:
    Day4();
    ~Day4();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
