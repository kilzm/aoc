#pragma once

#include <map>

#include "day.h"

class Days
{
  private:
    std::map<int, Day *> m_days;

  public:
    Days();
    ~Days();
    Day *get_day(int day);
};
