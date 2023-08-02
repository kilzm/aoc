#pragma once

#include <vector>
#include <string>
#include <unordered_map>

#include "day.h"

enum Op {
    NOP, ACC, JMP
};

struct Instruction {
    Op op;
    int arg;
};

class Day8 : public Day
{
  private:
    std::vector<Instruction> read_input(std::string filename);

  public:
    Day8();
    ~Day8();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
