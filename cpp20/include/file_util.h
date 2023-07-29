#pragma once

#include <vector>
#include <string>

class FileUtil {
    public:
        std::vector<std::string> read_lines(std::string filename);
        std::vector<std::string> read_split_double_newlines(std::string filename);
        std::vector<std::vector<char>> read_matrix(std::string filename);
};