#include <vector>
#include <string>

#include "day8.h"
#include "file_util.h"

Day8::Day8():Day(7) {}
Day8::~Day8() {}


std::vector<Instruction> Day8::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<Instruction> instructions;
    for (const auto& line : lines) {
        std::string op_s = line.substr(0, 3);
        std::string arg_s = line.substr(4);
        Instruction instr { 
            .op = op_s[0] == 'j' ? JMP : op_s[0] == 'a' ? ACC : NOP,
            .arg = std::stoi(arg_s) 
        };
        instructions.push_back(instr);
        
    }

    return instructions;
}


std::string Day8::part1(std::string filename)
{
    std::vector<Instruction> instructions = read_input(filename);
    std::vector<bool> ran(instructions.size(), false);

    int acc = 0;
    std::size_t p = 0;
    while (true) {
        auto in = instructions[p];
        if (ran[p]) break;
        ran[p] = true;
        
        if (in.op == JMP) {
            p += in.arg;
        } else if (in.op == ACC) {
            acc += in.arg;
            ++p;
        } else if (in.op == NOP) {
            ++p;
        }
    }

    return std::to_string(acc);
}


std::string Day8::part2(std::string filename)
{
    std::vector<Instruction> instructions = read_input(filename);

    auto swap = [](Instruction& p) {
        if (p.op == ACC) return false;
        if (p.op == JMP) p.op = NOP; 
        else p.op = JMP;
        return true;
    };

    const std::size_t last = instructions.size() - 1;

    auto run = [&](int& acc) {
        acc = 0;
        std::vector<bool> ran(instructions.size(), false);
        std::size_t p = 0;
        while (true) {
            if (p == last) return true;
            if (ran[p]) return false;
            ran[p] = true;
            
            auto in = instructions[p];
            if (in.op == JMP) {
                p += in.arg;
            } else if (in.op == ACC) {
                acc += in.arg;
                ++p;
            } else if (in.op == NOP) {
                ++p;
            }
        }
    };

    int acc;
    for (auto& in : instructions) {
        if (!swap(in)) continue;
        if (run(acc)) return std::to_string(acc);
        swap(in);
    }

    return "error: no solution found";
}
