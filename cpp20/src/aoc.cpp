#include <iostream>
#include <filesystem>
#include <chrono>

#include "days.h"

namespace fs = std::filesystem;
namespace ch = std::chrono;

void run_day(int day_num, Day *day, std::string file_path) {
    auto t0 = ch::high_resolution_clock::now();
    std::string part1 = day->part1(file_path);
    auto t1 = ch::high_resolution_clock::now();
    std::string part2 = day->part2(file_path);
    auto t2 = ch::high_resolution_clock::now();

    auto part1_time = ch::duration_cast<ch::microseconds>(t1 - t0);
    auto part2_time = ch::duration_cast<ch::microseconds>(t2 - t1);
    
    std::cout << "------------ Day " << day_num << " ------------" << std::endl;
    std::cout << "Part 1: " << part1 << " | Time: " << part1_time << std::endl;
    std::cout << "Part 2: " << part2 << " | Time: " << part2_time << std::endl;
    std::cout << "Combined: " << part1_time + part2_time << ::std::endl << std::endl;
}

int main() {
    Days days;
    const int num_days = 3;

    const bool test = false;

    fs::path file_path = __FILE__;
    fs::path data_dir = file_path.parent_path() / ".." / "data";
    if (test) { data_dir /= "test"; }

    for(int i = 1; i < num_days + 1; ++i) {
        Day *day = days.get_day(i);
        std::string file_name = "day" + std::to_string(i) + ".in";
        std::string file_path = (data_dir / file_name).string();
        run_day(i, day, file_path);
    }
}