//
//  CTime.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-26.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#ifndef __TimeUI__CTime__
#define __TimeUI__CTime__

#include <iostream>
#include <vector>
class CTime
{
private:
    CFTimeInterval _timeInterval;
public:
    int seconds;
    int mintues;
    int hours;
    int days;
    
    int secondLower;
    int secondUpper;
    int mintuesLower;
    int mintuesUpper;
    int hoursLower;
    int hoursUpper;
    int daysLower;
    int daysUpper;
    
    CTime(){};
    CTime(CFTimeInterval interval){ setTimeInterVal(interval);};
    void setTimeInterVal(CFTimeInterval interval);
    CFTimeInterval getTimeInterVal(){return _timeInterval;};
    void getHMSDisplay(std::vector<int>& displayVctor)
    {
        displayVctor.push_back(hoursUpper);
        displayVctor.push_back(hoursLower);
        displayVctor.push_back(mintuesUpper);
        displayVctor.push_back(mintuesLower);
        displayVctor.push_back(secondUpper);
        displayVctor.push_back(secondLower);
    };
};
#endif /* defined(__TimeUI__CTime__) */
