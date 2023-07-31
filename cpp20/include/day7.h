#pragma once

#include <vector>
#include <string>
#include <unordered_map>

#include "day.h"

typedef std::vector<std::pair<int, std::string>> BagContent;
typedef std::unordered_map<std::string, BagContent> Bags;

class Day7 : public Day
{
  private:
    Bags read_input(std::string filename);

  public:
    Day7();
    ~Day7();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
