//
//  DZLocalNotificationCenter.m
//  TimeUI
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZLocalNotificationCenter.h"
#import "DZSingletonFactory.h"
#import "NSDate+SSToolkitAdditions.h"
#import <NSDate-TKExtensions.h>

DEFINE_NSStringValue(LocalNotificationKey, localKey)

@implementation DZLocalNotificationCenter
+ (DZLocalNotificationCenter*) defaultCenter
{
    return DZSingleForClass([DZLocalNotificationCenter class]);
}
- (void)postNotificationAlertBody:(NSString *)alertBody
                         fireDate:(NSDate*)fireDate
                          withKey:(NSString*)key
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody        = alertBody;
    localNotification.alertLaunchImage = @"basketball";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = @{kDZLocalNotificationKey:key};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
- (void)postRepeatNotificationAlertBody:(NSString *)alertBody
                         fireDate:(NSDate*)fireDate
                          withKey:(NSString*)key
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody        = alertBody;
    localNotification.alertLaunchImage = @"basketball";
    localNotification.repeatInterval   = NSCalendarUnitDay;
    localNotification.repeatCalendar = [NSCalendar currentCalendar];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = @{kDZLocalNotificationKey:key};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
- (void) postAllNotifications
{
    NSDate* (^DateByAddingDays)(NSInteger) = ^(NSInteger days) {
       return  [[[[[NSDate date] TKDateByMovingToBeginningOfDay] TKDateByAddingHours:20] TKDateByAddingMinutes:30] TKDateByAddingDays:days];
        return [[NSDate date] TKDateByAddingSeconds:days*2];
    };
    NSDate* (^DateBuaddingDaysAndHours)(NSInteger,NSInteger) = ^(NSInteger days, NSInteger hours) {
        return  [[[[[NSDate date] TKDateByMovingToBeginningOfDay] TKDateByAddingHours:hours] TKDateByAddingMinutes:30] TKDateByAddingDays:days];
    };
    [self postNotificationAlertBody:@"昨天已经溜走，必须把他找回。揪住它的小尾巴，记下点滴回忆。"  fireDate:DateByAddingDays(1) withKey:@"1"];
    [self postNotificationAlertBody:@"两天就这么过去了，什么事情占用了两天的时间，赶紧来记一下吧！" fireDate:DateByAddingDays(2) withKey:@"2"];
    [self postNotificationAlertBody:@"2.5*24*60*60 = 216000(s) 已经丢失。" fireDate:DateBuaddingDaysAndHours(2,12) withKey:@"3.5"];
    [self postNotificationAlertBody:@"时光荏苒，岁月如梭。此处荒草成丘，沧海已变桑田。主人，时间不见了！！" fireDate:DateByAddingDays(3) withKey:@"3"];
    [self postRepeatNotificationAlertBody:@"时间如沙，总是轻易从指间溜走。你眼睁睁的看着他消逝，竟然一点都不心疼？" fireDate:DateByAddingDays(4) withKey:@"4"];
}

- (void) repostAllNotifications
{
    NSArray* allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification* notifi in allNotifications) {
        if (notifi.userInfo[kDZLocalNotificationKey]) {
            float duration = [notifi.userInfo[kDZLocalNotificationKey] floatValue];
            if (duration < 5) {
                [[UIApplication sharedApplication] cancelLocalNotification:notifi];
            }
        }
    }
    [self postAllNotifications];
}
@end

