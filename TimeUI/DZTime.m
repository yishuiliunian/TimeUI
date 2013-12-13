//
//  DZTime.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTime.h"
#import <NSDate-TKExtensions.h>
@implementation DZTime

-(NSString*) description
{
    return [NSString stringWithFormat:@" %@ %@ %@ %@ %@", self.begin, self.end, self.detail, self.typeId, self.guid];
}

- (NSDictionary*) parseDayCost
{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    NSInteger week =  [self.begin TKRealWeekday];
    if ([self.begin daysAreTheSame:self.end]) {
        dic[@(week)] = @([self.end timeIntervalSinceDate:self.begin]);
    }
    else
    {
         NSInteger days = [self.begin TKDaysBetweenDate:self.end];
        for (int i = 0 ; i < days; i ++) {
            if (i == 0) {
                NSDate* endDate = [self.begin TKDateByMovingToEndOfDay];
                dic[@(week)] = @([endDate timeIntervalSinceDate:self.begin]);
            }else if (i == days - 1)
            {
                NSDate* bedingDate = [self.end TKDateByMovingToBeginningOfDay];
                dic[@(week + days - 1)] = @([self.end timeIntervalSinceDate:bedingDate]);
            }
            else
            {
                dic[@(week + i)] = @(24*60*60);
            }
        }
    }
    return dic;
}
@end
