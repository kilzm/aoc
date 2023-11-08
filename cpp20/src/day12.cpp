#include <string>
#include <vector>
#include <algorithm>
#include <functional>

#include "day12.h"
#include "file_util.h"

Day12::Day12():Day(11) {}
Day12::~Day12() {}

std::vector<std::pair<char, int>> Day12::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    std::vector<std::pair<char, int>> instructions;
    for (const auto& line : lines) {
        instructions.push_back(std::make_pair(line[0], std::stoi(line.substr(1))));
    }
    return instructions;
}


std::string Day12::part1(std::string filename)
{
    std::vector<std::pair<char, int>> instructions = read_input(filename);
    int east = 0, north = 0;
    int rot = 0;
    
    for (const auto& instr : instructions) {
        char action = instr.first;
        int value = instr.second;
        switch (action) {
            case 'N': north += value; break;
            case 'S': north -= value; break;
            case 'E': east += value; break;
            case 'W': east -= value; break;
            case 'R': rot = (rot + (value / 90)) % 4; break;
            case 'L': rot = (rot - (value / 90) + 4) % 4; break;
            case 'F':
                switch (rot) {
                    case 0: east += value; break;
                    case 1: north -= value; break;
                    case 2: east -= value; break;
                    case 3: north += value; break;
                }
        }
    }

    int manhattan = std::abs(east) + std::abs(north);
    return std::to_string(manhattan); 
}


std::string Day12::part2(std::string filename)
{
    std::vector<std::pair<char, int>> instructions = read_input(filename);
    int sh_east = 0, sh_north = 0;
    int wp_east = 10, wp_north = 1;

    auto rotate = [&](int degrees) {
        int tmp;
        for (; degrees != 0; degrees -= 90) {
            tmp = wp_north;
            wp_north = wp_east;
            wp_east = -tmp;
        }
    };

    for (const auto& instr : instructions) {
        char action = instr.first;
        int value = instr.second;
        switch (action) {
            case 'N': wp_north += value; break;
            case 'S': wp_north -= value; break;
            case 'E': wp_east += value; break;
            case 'W': wp_east -= value; break;
            case 'F': 
                sh_east += value * wp_east; 
                sh_north += value * wp_north;
                break;
            case 'R': value = 360 - value;
            case 'L': rotate(value); break;
        }
    }

    int manhattan = std::abs(sh_east) + std::abs(sh_north);
    return std::to_string(manhattan); 
}
