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