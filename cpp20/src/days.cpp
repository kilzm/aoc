#include <map>

#include "day.h"
#include "days.h"

#include "day1.h"
#include "day2.h"
#include "day3.h"
#include "day4.h"

Days::Days()
{
    m_days[0] = new Day1();
    m_days[1] = new Day2();
    m_days[2] = new Day3();
    m_days[3] = new Day4();
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