#pragma once

#include <vector>
#include <string>

#include "day.h"

typedef struct {
    size_t timestamp;
    std::vector<int> buses;
} BusSchedule;

class Day13 : public Day
{
  private:
    BusSchedule read_input(std::string filename);

  public:
    Day13();
    ~Day13();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
