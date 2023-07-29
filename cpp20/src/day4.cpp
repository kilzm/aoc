#include <vector>
#include <string>
#include <unordered_map>
#include <regex>
#include <iostream>

#include "day4.h"
#include "file_util.h"

Day4::Day4():Day(3) {};
Day4::~Day4() {};

std::vector<std::unordered_map<std::string, std::string>> Day4::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> blocks = fileutil.read_split_double_newlines(filename);
    std::vector<std::unordered_map<std::string, std::string>> passports;

    auto split_into_pair = [](std::string key_val) { 
        std::size_t pos = key_val.find(':');
        std::pair<const std::string, std::string> result(key_val.substr(0, pos), key_val.substr(pos));
        return result;
    };

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

    for (const auto& block : blocks) {
        std::vector<std::string> fields = split_into_fields(block);

        std::unordered_map<std::string, std::string> passport;
        for (const auto& field : fields) {
            passport.insert(split_into_pair(field));
        }
        passports.push_back(passport);
    }
    return passports;
}

std::string Day4::part1(std::string filename)
{
    std::vector<std::unordered_map<std::string, std::string>> passports = read_input(filename);
    int valid_count = 0;
    for (const auto& passport : passports) {
        valid_count += (passport.size() - int(passport.contains("cid"))) / 7;
    }
    return std::to_string(valid_count);
}

std::string Day4::part2(std::string filename)
{
    return "";
}
