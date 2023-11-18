#pragma once

#include <vector>
#include <string>
#include <cstdint>

#include "day.h"




typedef struct {
    enum class Tag { MEM, MASK } tag;
    union {
        struct {
            size_t address;
            uint64_t value;
        } mem;
        struct {
            uint64_t mask_zero, mask_one, mask_x;
        } mask;
    } i;
} MemInstruction;

class Day14 : public Day
{
  private:
    std::vector<MemInstruction> read_input(std::string filename);

  public:
    Day14();
    ~Day14();
    std::string part1(std::string filename);
    std::string part2(std::string filename);
};
