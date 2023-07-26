#include <string>
#include <vector>
#include <fstream>
#include <iostream>

#include "file_util.h"


std::vector<std::string> FileUtil::read_lines(std::string filename)
{
    std::ifstream infile(filename);

    if (!infile) {
        std::cerr << "error: opening file " << filename << std::endl;
    }

    std::vector<std::string> result;
    std::string line;
    while (std::getline(infile, line)) {
        result.push_back(line);
    }

    infile.close();
    return result;
}

std::vector<std::vector<char>> FileUtil::read_matrix(std::string filename)
{
    std::vector<std::string> lines = read_lines(filename);
    std::vector<std::vector<char>> result;
    for (auto line : lines) {
        std::vector<char> row(line.begin(), line.end());
        result.push_back(row);
    }
    return result;
}