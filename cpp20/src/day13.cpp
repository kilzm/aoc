#include <string>
#include <sstream>
#include <vector>
#include <climits>
#include <numeric>
#include <tuple>

#include "day13.h"
#include "file_util.h"

Day13::Day13():Day(12) {}
Day13::~Day13() {}

BusSchedule Day13::read_input(std::string filename)
{
    FileUtil fileutil;
    std::vector<std::string> lines = fileutil.read_lines(filename);
    BusSchedule schedule;
    schedule.timestamp = (size_t) std::stoull(lines[0]);
    std::stringstream ss(lines[1]);
    std::string bus;
    while(std::getline(ss, bus, ',')) {
        schedule.buses.push_back(bus == "x" ? -1 : std::stoi(bus));
    }

    return schedule;
}


std::string Day13::part1(std::string filename)
{
    BusSchedule schedule = read_input(filename);
    size_t timestamp = schedule.timestamp;
    int opt_bus, opt_time = INT_MAX;
    int time;
    for (auto& bus : schedule.buses) {
        if (bus == -1) continue;
        time = bus * ((timestamp - 1) / bus + 1);
        if (time < opt_time) {
            opt_time = time;
            opt_bus = bus;
        }
    }
    return std::to_string((opt_time - timestamp) * opt_bus);
}


std::string Day13::part2(std::string filename)
{
    BusSchedule schedule = read_input(filename);

    auto xgcd = [](int64_t a, int64_t b) -> std::pair<int64_t, int64_t> {
        int64_t r = b , rr = a, s = 0, ss = 1, t = 1, tt = 0;
        while (r != 0) {
            int64_t q = rr / r;
            std::tie(r, rr) = std::make_pair(rr - q * r, r);
            std::tie(s, ss) = std::make_pair(ss - q * s, s);
            std::tie(t, tt) = std::make_pair(tt - q * t, t);
        }
        return {ss, tt};
    };

    std::vector<std::pair<int64_t, int64_t>> buses;
    for (int64_t i = 0; i < static_cast<int64_t>(schedule.buses.size()); ++i) {
        int bus = schedule.buses[i];
        if (bus == -1) continue;
        buses.push_back(std::make_pair((bus - i) % bus, bus));
    }
    
    int64_t m = std::accumulate(buses.begin(), buses.end(), static_cast<int64_t>(1),
                                [](int64_t acc, auto& bus) { return acc * bus.second; });
    int64_t result = 0;
    for (size_t n = 0; n < buses.size(); ++n) {
        auto bus_n = buses[n];
        int64_t m_n = m / bus_n.second;
        auto [_, t] = xgcd(bus_n.second, m_n);
        result += (t * m_n * bus_n.first) % m;
    }
    return std::to_string(result % m < 0 ? result % m + m : result % m);
}
