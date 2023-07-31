#pragma once

#include <vector>
#include <string>

class FileUtil {
    public:
        std::vector<std::string> read_lines(std::string filename);
        std::vector<std::vector<std::string>> read_word_array(std::string filename);
};