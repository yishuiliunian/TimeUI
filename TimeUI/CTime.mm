//
//  CTime.cpp
//  TimeUI
//
//  Created by Stone Dong on 14-1-26.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#include "CTime.h"



void CTime::setTimeInterVal(CFTimeInterval interval)
{
    int64_t time = floor(interval);
    seconds = time % 60;
    secondLower = seconds%10;
    secondUpper = seconds/10;
    
    mintues = (int)floor(time/60)%60;
    mintuesLower = mintues%10;
    mintuesUpper = mintues / 10;
    
    hours = (int)floor(time/60/60)%24;
    hoursLower = hours%10;
    hoursUpper = hours/10;
    
    days = floor(time / (60*60*24));
    daysLower = days%10;
    daysUpper = days/10;
    _timeInterval = interval;
}