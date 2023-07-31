#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>

#include "file_util.h"


std::vector<std::string> FileUtil::read_lines(std::string filename)
{
    std::ifstream infile(filename);

    if (!infile) {
        std::cerr << "error: opening file " << filename << std::endl;
    }

    std::vector<std::string> lines;
    std::string line;
    while (std::getline(infile, line)) {
        lines.push_back(line);
    }

    infile.close();
    return lines;
}

std::vector<std::vector<std::string>> FileUtil::read_word_array(std::string filename)
{
    std::ifstream infile(filename);

    if (!infile) {
        std::cerr << "error: opening file " << filename << std::endl;
    }
    
    std::vector<std::vector<std::string>> split_lines;
    std::string line;
    while (std::getline(infile, line)) {
        std::istringstream linestream(line);
        std::string word;
        std::vector<std::string> words;
        while (std::getline(linestream, word, ' ')) {
            words.push_back(word);
        }
        split_lines.push_back(words);
    }

    infile.close();
    return split_lines;
}