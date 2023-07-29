#include <vector>
#include <string>
#include <sstream>
#include <functional>
#include <unordered_map>
#include <iostream>

#include "day4.h"
#include "file_util.h"

Day4::Day4():Day(3) {};
Day4::~Day4() {};

Passports Day4::read_input(std::string filename)
{
    FileUtil fileutil;
    std::string s = "abc";
    std::vector<std::string> lines = fileutil.read_lines(filename);
    lines.push_back("\n");
    Passports passports;

    auto split_into_pair = [](std::string key_val) { 
        std::size_t pos = key_val.find(':');
        std::pair<std::string, std::string> result(key_val.substr(0, pos), key_val.substr(pos + 1));
        return result;
    };

    auto parse_passport = [&](std::vector<std::string> block) {
        Passport passport;
        std::string field;
        for (const auto& line : block) {
            std::istringstream word_stream(line);
            while (std::getline(word_stream, field, ' ')) {
                passport.push_back(split_into_pair(field));
            }
        }
        return passport;
    };

    auto block_begin = lines.begin();
    decltype(block_begin) block_end;
    for (auto it = lines.begin(); it != lines.end(); ++it) {
        if ((*it).empty()) {
            block_end = it;
            std::vector<std::string> block(block_begin, block_end);
            passports.push_back(parse_passport(block));
            block_begin = block_end + 1;
        }
    }
    return passports;
}

std::string Day4::part1(std::string filename)
{
    Passports passports = read_input(filename);
    auto contains_cid = [](Passport passport) {
        for (auto& pair : passport) {
            if (pair.first == "cid") return true;
        }
        return false;
    };

    int valid_count = 0;
    for (const auto& passport : passports) {
        valid_count += (passport.size() - int(contains_cid(passport))) / 7;
    }
    return std::to_string(valid_count);
}

std::string Day4::part2(std::string filename)
{
    auto check_year = [](std::string year_s, int lower, int upper) -> bool {
        try {
            int year = std::stoi(year_s);
            return lower <= year && year <= upper;
        } catch (std::exception& e) {
            return false;
        }
    };

    std::unordered_map<std::string, std::function<bool(const std::string&)>> check_funs;
    check_funs["byr"] = [&](std::string byr_s) { return check_year(byr_s, 1920, 2002); };
    check_funs["iyr"] = [&](std::string iyr_s) { return check_year(iyr_s, 2010, 2020); };
    check_funs["eyr"] = [&](std::string eyr_s) { return check_year(eyr_s, 2020, 2030); };
    check_funs["hgt"] = [ ](std::string hgt_s) {
        std::size_t size;
        try {
            size = std::stoi(hgt_s.substr(0, hgt_s.size() - 2));
        } catch (std::exception& e) {
            return false;
        }
        std::string unit = hgt_s.substr(hgt_s.size() - 2);
        bool is_cm = unit == "cm";
        bool is_in = unit == "in";
        return (is_cm && 150 <= size && size <= 193) || (is_in && 59 <= size && size <= 76);
    };
    check_funs["hcl"] = [](std::string hcl_s) {
        if (hcl_s[0] != '#' || hcl_s.size() != 7) return false;
        std::string hex = hcl_s.substr(1);
        auto check_char = [](char c) { return std::isdigit(c) || ('a' <= c && c <= 'f'); };
        for (auto c : hex) {
            if (!check_char(c)) return false;
        }
        return true;
    };
    check_funs["ecl"] = [](std::string ecl_s) {
        const std::vector<std::string> colors = {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"};
        return std::find(colors.begin(), colors.end(), ecl_s) != colors.end();
    };
    check_funs["pid"] = [](std::string pid_s) {
        if (pid_s.size() != 9) return false;
        for (auto c : pid_s) {
            if (!std::isdigit(c)) return false;
        }
        return true;
    };

    Passports passports = read_input(filename);
    int valid_count = 0;
    for (const auto& passport : passports) {
        int required = 0;
        bool valid = true;
        for (const auto& pair : passport) {
            if (pair.first == "cid") continue;
            ++required;
            if (!check_funs[pair.first](pair.second)) {
                valid = false;
                break;
            }
        }
        valid &= required == 7;
        if (valid) ++valid_count;
    }

    return std::to_string(valid_count);
}