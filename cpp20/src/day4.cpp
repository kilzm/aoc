#include <vector>
#include <string>
#include <sstream>
#include <functional>

#include "day4.h"
#include "file_util.h"

Day4::Day4():Day(3) {};
Day4::~Day4() {};

Passports Day4::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> blocks = fileutil.read_split_double_newlines(filename);
    Passports passports;

    auto split_into_fields = [](std::string block) {
        std::vector<std::string> fields;
        std::istringstream line_stream(block);
        std::string field, line;
        while (std::getline(line_stream, line)) {
            std::istringstream word_stream(line);
            while (std::getline(word_stream, field, ' ')) {
                fields.push_back(field);
            }
        }
        return fields;
    };

    auto split_into_pair = [](std::string key_val) { 
        std::size_t pos = key_val.find(':');
        std::pair<std::string, std::string> result(key_val.substr(0, pos), key_val.substr(pos + 1));
        return result;
    };

    for (const auto& block : blocks) {
        std::vector<std::string> fields = split_into_fields(block);
        Passport passport;
        for (const auto& field : fields) {
            passport.push_back(split_into_pair(field));
        }
        passports.push_back(passport);
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

    std::unordered_map<std::string, std::function<bool(const std::string&)>> check_funs = {
        {"byr", [&](std::string byr_s) { return check_year(byr_s, 1920, 2002); }},
        {"iyr", [&](std::string iyr_s) { return check_year(iyr_s, 2010, 2020); }},
        {"eyr", [&](std::string eyr_s) { return check_year(eyr_s, 2020, 2030); }},
        {"hgt", [ ](std::string hgt_s) {
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
        }},
        {"hcl", [ ](std::string hcl_s) {
            if (hcl_s[0] != '#' || hcl_s.size() != 7) return false;
            std::string hex = hcl_s.substr(1);
            auto check_char = [](char c) { return ('0' <= c && c <= '9') || ('a' <= c && c <= 'f'); };
            for (auto c : hex) {
                if (!check_char(c)) {
                    return false;
                }
            }
            return true;
        }},
        {"ecl", [ ](std::string ecl_s) {
            return (ecl_s == "amb" || ecl_s == "blu" || ecl_s == "brn" || 
                ecl_s == "gry" || ecl_s == "grn" || ecl_s == "hzl" || ecl_s == "oth");
        }},
        {"pid", [ ](std::string pid_s) {
            if (pid_s.size() != 9) return false;
            for (auto c : pid_s) {
                if (!('0' <= c && c <= '9')) return false;
            }
            return true;
        }},
    };

    Passports passports = read_input(filename);
    int valid_count = 0;
    for (auto& passport : passports) {
        int required = 0;
        bool valid = true;
        for (auto& pair : passport) {
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
