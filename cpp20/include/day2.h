#pragma once

#include <vector>

#include "day.h"

struct policy
{
    int lower;
    int upper;
    char character;
    std::string password;
};

class Day2 : public Day
{
  private:
    std::vector<policy> read_input(std::string filename);

  public:
    Day2();
    ~Day2();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
