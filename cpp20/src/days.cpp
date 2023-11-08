#include <map>

#include "day.h"
#include "days.h"

#include "day1.h"
#include "day2.h"
#include "day3.h"
#include "day4.h"
#include "day5.h"
#include "day6.h"
#include "day7.h"
#include "day8.h"
#include "day9.h"
#include "day10.h"
#include "day11.h"
#include "day12.h"
// #include "day13.h"
// #include "day14.h"
// #include "day15.h"
// #include "day16.h"
// #include "day17.h"
// #include "day18.h"
// #include "day19.h"
// #include "day20.h"
// #include "day21.h"
// #include "day22.h"
// #include "day23.h"
// #include "day24.h"

Days::Days()
{
    m_days[0] = new Day1();
    m_days[1] = new Day2();
    m_days[2] = new Day3();
    m_days[3] = new Day4();
    m_days[4] = new Day5();
    m_days[5] = new Day6();
    m_days[6] = new Day7();
    m_days[7] = new Day8();
    m_days[8] = new Day9();
    m_days[9] = new Day10();
    m_days[10] = new Day11();
    m_days[11] = new Day12();
    // m_days[12] = new Day13();
    // m_days[13] = new Day14();
    // m_days[14] = new Day15();
    // m_days[15] = new Day16();
    // m_days[16] = new Day17();
    // m_days[17] = new Day18();
    // m_days[18] = new Day19();
    // m_days[19] = new Day20();
    // m_days[20] = new Day21();
    // m_days[21] = new Day22();
    // m_days[22] = new Day23();
    // m_days[23] = new Day24();
}

Days::~Days()
{
    for(auto& day_entry : m_days) 
    {
        delete day_entry.second;
    }
    m_days.clear();
}

Day *Days::get_day(int day)
{
    return m_days[day - 1];
}
