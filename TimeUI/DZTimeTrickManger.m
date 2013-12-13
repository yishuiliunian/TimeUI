//
//  DZTimeTrickManger.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTimeTrickManger.h"
#import "DZUserDataManager.h"
#import "DZTimeType.h"
#import "DZTime.h"
#import "DZDBManager.h"
#import <TheAmazingAudioEngine.h>
//

static NSString* const kDZLastTrickDate = @"kDZLastTrickDate";
static NSString* const kDZCurrentTimeType = @"kDZCurrentTimeType";
@implementation DZTimeTrickManger
+ (DZTimeTrickManger*) shareManager
{
    
    static DZTimeTrickManger* share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[DZTimeTrickManger alloc] init];
    });
    return share;
}

- (void) setLastTrickDate:(NSDate *)lastTrickDate
{
    [[DZUserDataManager shareManager] setActiveUserData:lastTrickDate forKey:kDZLastTrickDate];
}

- (NSDate*) lastTrickDate
{
    NSDate* date = [[DZUserDataManager shareManager] activeUserDataForKey:kDZLastTrickDate];
    if (!date) {
        date = [NSDate date];
        [self setLastTrickDate:date];
    }
    return date;
}

- (void) addTimeLogWithType:(DZTimeType*)type detail:(NSString*)detail
{
    DZTime* time = [[DZTime alloc] init];
    time.detail = detail ? detail : @"";
    time.begin = self.lastTrickDate;
    time.end = [NSDate date];
    [self setLastTrickDate:time.end];
    time.typeId = type.identifiy;
    time.guid = [DZGlobals genGUID];
    [DZActiveTimeDataBase updateTime:time];
}

- (float) alreadyCostTime
{
    return ABS([self.lastTrickDate timeIntervalSinceNow]);
}

- (void) setTimeType:(DZTimeType *)timeType
{
    [[DZUserDataManager shareManager] setActiveUserData:timeType.identifiy forKey:kDZCurrentTimeType];
}

- (DZTimeType*) timeType
{
    NSString* type = [[DZUserDataManager shareManager] activeUserDataForKey:kDZCurrentTimeType];
    if (type) {
        return [DZActiveTimeDataBase tiemTypeByIdentifiy:type];
    }
    else
    {
        NSArray* all = [DZActiveTimeDataBase allTimeTypes];
        if (all.count) {
            DZTimeType* aType = all.firstObject;
            [[DZUserDataManager shareManager] setActiveUserData:aType.identifiy forKey:kDZCurrentTimeType];
            return aType;
        }
    }
    return nil;
}
- (void) addTimeWithDetail:(NSString*)detail
{
    [self addTimeLogWithType:self.timeType detail:detail];
}
@end
