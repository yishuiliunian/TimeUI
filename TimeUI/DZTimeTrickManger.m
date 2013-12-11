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
//

static NSString* const kDZLastTrickDate = @"kDZLastTrickDate";

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
@end
