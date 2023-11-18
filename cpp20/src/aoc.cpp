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
    
    day->part1_result = part1;

    auto t2 = ch::high_resolution_clock::now();
    std::string part2 = day->part2(file_path);
    auto t3 = ch::high_resolution_clock::now();

    auto part1_time = ch::duration_cast<ch::microseconds>(t1 - t0);
    auto part2_time = ch::duration_cast<ch::microseconds>(t3 - t2);
    
    std::cout << "------------ Day " << day_num << " ------------" << std::endl;
    std::cout << "Part 1: " << part1 << " | Time: " << part1_time << std::endl;
    std::cout << "Part 2: " << part2 << " | Time: " << part2_time << std::endl;
    std::cout << "Combined: " << part1_time + part2_time << ::std::endl << std::endl;
}

int main(int argc, char *argv[]) {
    fs::path exec_dir = fs::path(argv[0]).parent_path();
    Days days;
    const int num_days = 14;
    const bool test = false;


    std::string home_dir;
    if (const char* home_env = std::getenv("HOME")) {
        home_dir = home_env;
    } else {
        std::cerr << "$HOME is unset" << std::endl;
        exit(1);
    }
    
    std::string data_dir;
    if (test) {
        data_dir = exec_dir.string() + "/../data/test";
    } else {
        data_dir = home_dir + "/.aoc_data/2020";
    }

    for(int i = 1; i < num_days + 1; ++i) {
        Day *day = days.get_day(i);
        std::string file_name = "day" + std::to_string(i) + ".in";
        std::string file_path = data_dir + "/" + file_name;
        run_day(i, day, file_path);
    }
}
