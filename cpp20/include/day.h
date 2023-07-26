#pragma once

#include <string>

class Day
{
  private:
    int m_day;
  
  public:
    Day(int day);
    virtual ~Day();
    virtual std::string part1(std::string filename);
    virtual std::string part2(std::string filename);
};
