#pragma once

#include <string>
#include <optional>

class Day
{
  private:
    int m_day;
  
  public:
    Day(int day);
    virtual ~Day();
    virtual std::string part1(std::string filename);
    virtual std::string part2(std::string filename);
    std::optional<std::string> part1_result = {};
};
