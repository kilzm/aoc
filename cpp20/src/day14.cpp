#include <algorithm>
#include <bit>
#include <cstdint>
#include <string>
#include <vector>
#include <unordered_map>
#include <immintrin.h>

#include "day14.h"
#include "file_util.h"

Day14::Day14():Day(13) {}
Day14::~Day14() {}


std::vector<MemInstruction> Day14::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<MemInstruction> instructions;
    for (const auto& line : lines) {
        MemInstruction instruction{};
        if (line.starts_with("mem")) {
            instruction.tag = MemInstruction::Tag::MEM;
            instruction.i.mem.address = std::stoull(line.substr(4, line.find(']')));
            instruction.i.mem.value = stoul(line.substr(line.find('=') + 2));
        } else {
            instruction.tag = MemInstruction::Tag::MASK;
            std::string mask_str = line.substr(7);
            size_t i = 0;
            for (auto it = mask_str.rbegin(); it != mask_str.rend(); ++it) {
                switch (*it) {
                    case '0': instruction.i.mask.mask_zero |= (uint64_t) 1 << i; break;
                    case '1': instruction.i.mask.mask_one |= (uint64_t) 1 << i; break;
                    default: instruction.i.mask.mask_x |= (uint64_t) 1 << i; break;
                }
                ++i;
            }
        }
        instructions.push_back(instruction);
    }
    return instructions;
}


std::string Day14::part1(std::string filename)
{
    std::vector<MemInstruction> instructions = read_input(filename);
    uint64_t mask_zero, mask_one;
    std::unordered_map<size_t, uint64_t> memory;
    size_t result = 0;
    for (const auto& instruction : instructions) {
        switch (instruction.tag) {
            case MemInstruction::Tag::MASK:
                mask_zero = instruction.i.mask.mask_zero;
                mask_one = instruction.i.mask.mask_one;
                break;
            case MemInstruction::Tag::MEM:
                size_t address = instruction.i.mem.address;
                uint64_t value = instruction.i.mem.value;
                value &= ~mask_zero;
                value |= mask_one;
                result += value;
                if (memory.contains(address)) result -= memory[address];
                memory[address] = value;
                break;
        }
    }
    return std::to_string(result);
}


std::string Day14::part2(std::string filename)
{
    std::vector<MemInstruction> instructions = read_input(filename);
    uint64_t mask_one, mask_x;
    std::unordered_map<size_t, uint64_t> memory;
    size_t result = 0;
    for (const auto& instruction : instructions) {
        switch (instruction.tag) {
            case MemInstruction::Tag::MASK:
                mask_one = instruction.i.mask.mask_one;
                mask_x = instruction.i.mask.mask_x;
                break;
            case MemInstruction::Tag::MEM:
                size_t address = instruction.i.mem.address;
                size_t value = instruction.i.mem.value;
                address |= mask_one;
                address &= ~mask_x;
                for (uint64_t variation = 0; variation < (uint64_t) 1 << std::popcount(mask_x); ++variation) {
                    uint64_t address_v = _pdep_u64(variation, mask_x) | address;
                    result += value;
                    if (memory.contains(address_v)) result -= memory[address_v];
                    memory[address_v] = value;
                }
                break;
        }
    }
    return std::to_string(result);
}
