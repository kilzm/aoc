#include <string>
#include <vector>
#include <algorithm>
#include <functional>
#include <iostream>

#include "day11.h"
#include "file_util.h"

Day11::Day11():Day(10) {}
Day11::~Day11() {}

std::vector<std::string> Day11::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> seats = fileutil.read_lines(filename);
    return seats;
}

void print_seats(std::vector<std::string> &seats) {
    for (const auto& row : seats) std::cout << row << std::endl;
    std::cout << std::endl;
}

bool update_seats(std::vector<std::string> &seats, int rows, int cols, int threshhold,
                  const std::function<size_t (int, int)>& get_occupied) 
{
    bool changed = false;
    auto new_seats = seats;
    for (int r = 0; r < rows; ++r) {
        for (int c = 0; c < cols; ++c) {
            char current = seats[r][c];
            int occupied = get_occupied(r, c);
            if (occupied == 0 && current == 'L') {
                new_seats[r][c] = '#';
                changed = true;
            } else if (occupied >= threshhold && current == '#') {
                new_seats[r][c] = 'L';
                changed = true;
            }
        }
    }
    std::copy(new_seats.begin(), new_seats.end(), seats.begin());
    return changed;
}

std::string Day11::part1(std::string filename)
{
    std::vector<std::string> seats = read_input(filename);
    int rows = seats.size();
    int cols = seats[0].size();

    auto get_occupied = [&](int r, int c) -> size_t {
        size_t occupied = 0;
        for (int rr = std::max(0, r - 1); rr <= std::min(rows - 1, r + 1); ++rr) {
            for (int cc = std::max(0, c - 1); cc <= std::min(cols - 1, c + 1); ++cc) {
                if (r == rr && c == cc) continue;
                if (seats[rr][cc] == '#') ++occupied;
            }
        }
        return occupied;
    };

    bool changed = true;
    while (changed) {
        changed = update_seats(seats, rows, cols, 4, get_occupied);
    }
    
    size_t occupied_count = 0;
    for (const auto& row : seats) {
        occupied_count += std::count(row.begin(), row.end(), '#');
    }

    return std::to_string(occupied_count);
}


std::string Day11::part2(std::string filename)
{
    std::vector<std::string> seats = read_input(filename);
    int rows = seats.size();
    int cols = seats[0].size();

    auto is_in_bounds = [&](int r, int c) { return 0 <= r && r < rows && 0 <= c && c < rows; };

    auto get_occupied = [&](int r, int c) -> size_t {
        size_t occupied = 0;
        const std::vector<std::pair<int, int>> directions =
            {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};

        for (const auto& direction : directions) {
            int dr = direction.first, dc = direction.second;
            int rr = r + dr, cc = c + dc;
            while (is_in_bounds(rr, cc)) {
                char current = seats[rr][cc];
                if (current == '#') ++occupied;
                if (current != '.') break;
                rr += dr;
                cc += dc;
            }
        }

        return occupied;
    };

    bool changed = true;
    while (changed) {
        changed = update_seats(seats, rows, cols, 5, get_occupied);
    }
    
    size_t occupied_count = 0;
    for (const auto& row : seats) {
        occupied_count += std::count(row.begin(), row.end(), '#');
    }

    return std::to_string(occupied_count);
}
