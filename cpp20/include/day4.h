#pragma once

#include <vector>
#include <string>
#include <unordered_map>

#include "day.h"


typedef std::vector<std::pair<std::string, std::string>> Passport;
typedef std::vector<Passport> Passports;

class Day4 : public Day
{
  private:
    Passports read_input(std::string filename);

  public:
    Day4();
    ~Day4();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
