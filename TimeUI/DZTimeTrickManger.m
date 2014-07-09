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
#import "DZAnalysisManager.h"
#import "DZMessageCenter.h"
//
#import "DZEditTimeViewController.h"
#import "DZRestoreTrickDataNI.h"

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


- (void) restoreTrickDate:(NSDate*)date
{
    [self setLastTrickDate:date];
    [DZDefaultNotificationCenter postMessage:kDZNotification_restoreDate userInfo:nil];
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
    if (!type) {
        DDLogCError(@"时间类型是空的，坑爹呢！");
        return;
    }
    DZTime* time = [[DZTime alloc] initGenGUID];
    time.detail = detail ? detail : @"";
    time.dateBegin = self.lastTrickDate;
    time.dateEnd = [NSDate date];
    [self setLastTrickDate:time.dateEnd];
    time.typeGuid = type.guid;
    DZEditTimeViewController* editVC = [[DZEditTimeViewController alloc] initWithInitTime:time];
    [[UIApplication sharedApplication].keyWindow.rootViewController.pdSuperViewController
     
     pdPresentViewController:[[UINavigationController alloc] initWithRootViewController:editVC]
                                                                                                         animated:YES completion:^{
        
    }];
}

- (float) alreadyCostTime
{
    return ABS([self.lastTrickDate timeIntervalSinceNow]);
}

- (void) setTimeType:(DZTimeType *)timeType
{
    [[DZUserDataManager shareManager] setActiveUserData:timeType.guid forKey:kDZCurrentTimeType];
}

- (DZTimeType*) timeType
{
    NSString* type = [[DZUserDataManager shareManager] activeUserDataForKey:kDZCurrentTimeType];
    DZTimeType* timeType = nil;
    if (type) {
        timeType = [DZActiveTimeDataBase timeTypByGUID:type];
    }
    if (timeType) {
        return timeType;
    }
    NSArray* all = [DZActiveTimeDataBase allTimeTypes];
    if (all.count) {
        DZTimeType* aType = all.firstObject;
        [[DZUserDataManager shareManager] setActiveUserData:aType.guid forKey:kDZCurrentTimeType];
        return aType;
    }
    return nil;
}
- (void) addTimeWithDetail:(NSString*)detail
{
    [self addTimeLogWithType:self.timeType detail:detail];
}
@end
