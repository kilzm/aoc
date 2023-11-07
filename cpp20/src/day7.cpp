#include <vector>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <iostream>
#include <queue>

#include "day7.h"
#include "file_util.h"

Day7::Day7():Day(6) {}
Day7::~Day7() {}

Bags Day7::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::vector<std::string>> word_array = fileutil.read_word_array(filename);
    Bags bags;

    for (const auto& words : word_array) {
        std::string color = words[0] + words[1];
        BagContent content;
        for (std::size_t i = 4; i < words.size(); i += 4) {
            if (words[i] == "no") continue;
            int amount = std::stoi(words[i]);
            std::string color = words[i + 1] + words[i + 2];
            content.push_back(std::make_pair(amount, color));
        }
        bags[color] = content;
    }

    return bags;
}


std::string Day7::part1(std::string filename) {
    Bags bags = read_input(filename);
    std::unordered_map<std::string, std::vector<std::string>> parents;
    for (const auto& bag : bags) {
        const auto color = bag.first;
        const auto nbags = bag.second;
        for (const auto& nbag : nbags) {
            const auto ncolor = nbag.second;
            parents[ncolor].push_back(color);
        }
    }

    std::unordered_set<std::string> pbags;
    std::queue<std::string> bagq;
    bagq.push("shinygold");
    while (!bagq.empty()) {
        const auto bag = bagq.front();
        bagq.pop();
        for (const auto& nbag : parents[bag]) {
            if (!pbags.contains(nbag)) {
                bagq.push(nbag);
                pbags.insert(nbag);
            }
        }
    }

    return std::to_string(pbags.size());
}


std::string Day7::part2(std::string filename)
{
    Bags bags = read_input(filename);

    const std::string root = "shinygold";
    std::queue<std::pair<int, std::string>> bagq;

    bagq.push(std::make_pair(1, root));

    std::size_t total = 0;
    while (!bagq.empty()) {
        const auto cbag = bagq.front();
        bagq.pop();

        for (const auto& nbag : bags[cbag.second]) {
            const auto ncolor = nbag.second;
            int amount = cbag.first * nbag.first;
            bagq.push(std::make_pair(amount, ncolor));
            total += amount;
        }
    }
    
    return std::to_string(total);   
}
