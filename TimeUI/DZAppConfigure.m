//
//  DZAppConfigure.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAppConfigure.h"
#import <DDLog.h>
#import <DDAbstractDatabaseLogger.h>
#import <DDASLLogger.h>
#import <DDTTYLogger.h>
//
#import "DZDBManager.h"
#import "DZTime.h"
#import "DZTimeType.h"
#import "DZTimeTrickManger.h"
#import "DZNotificationCenter.h"
#import "DZTestInterface.h"
#import "DZTokenManager.h"
#import "DZSingletonFactory.h"
#import "DZShakeRecognizedWindow.h"
#import "MTA.h"
#import "DZContextManager.h"
#import "DZThemeManager.h"
#import <TestFlight.h>
#import "DZUserDataManager.h"
#import "DZSelecteTypeInterface.h"
#import "DZAnalysisNotificationInterface.h"
//
static NSString* const DZThirdToolKeyQQMTA = @"IN1Q4USC75PL";

@interface DZAppConfigure () <DZNotificationInitDelegaete, DZSyncContextChangedInterface>

@end

@implementation DZAppConfigure

+ (DZAppConfigure*) shareConfiure
{
    return DZSingleForClass([DZAppConfigure class]);
}

- (void) syncContextChangedFrom:(DZSyncContext)origin toContext:(DZSyncContext)aim
{
    
}

- (DZDecodeNotificationBlock) decodeNotification:(NSString *)message forCenter:(DZNotificationCenter *)center
{
    if ([message isEqualToString:@"a"]) {
        return ^(id observer, NSDictionary *userInfo) {
            if ([observer conformsToProtocol:@protocol(DZTestInterface)]) {
                if ([observer respondsToSelector:@selector(didGetMessage)]) {
                    SendSelectorToObjectInMainThreadWithoutParams(@selector(didGetMessage), observer);
                }
            }
        };
    }else if([message isEqualToString:DZShareNotificationMessage])
    {
        return ^(id observer, NSDictionary *userInfo) {
            if ([observer respondsToSelector:@selector(didGetShareMessage)]) {
                SendSelectorToObjectInMainThreadWithoutParams(@selector(didGetShareMessage), observer);
            }
        };
    }
    else if ([message isEqualToString:kDZSyncContextChangedMessage])
    {
        return ^(id observer, NSDictionary *userInfo)
        {
            DZSyncContext o = (DZSyncContext)[userInfo[@"old"] intValue];
            DZSyncContext n = (DZSyncContext)[userInfo[@"new"] intValue];
            if ([observer respondsToSelector:@selector(syncContextChangedFrom:toContext:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer syncContextChangedFrom:o toContext:n];
                });
            }
        };
    } else if ([message isEqualToString:kDZNotification_selectedType]) {
        return ^(id observer, NSDictionary *userInfo)
        {
            DZTimeType* type = userInfo[@"type"];
            if ([observer respondsToSelector:@selector(didSelectedTimeType:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer didSelectedTimeType:type];
                });
            }
        };
    } else if ([message isEqualToString:kDZNotification_parase_count]) {
        return ^(id observer, NSDictionary *userInfo)
        {
            int count = [userInfo[@"count"] intValue];
            NSString* key = userInfo[@"key"];
            if ([observer respondsToSelector:@selector(parasedCount:forKey:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer parasedCount:count forKey:key];
                });
            }
        };
    } else if ([message isEqualToString:kDZNotification_time_cost])
    {
        return ^(id observer, NSDictionary *userInfo)
        {
            NSString* guid = userInfo[@"guid"];
            NSTimeInterval cost  = [userInfo[@"cost"] doubleValue];
            if ([observer respondsToSelector:@selector(parasedTimeCost:forTypeGUID:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer parasedTimeCost:cost forTypeGUID:guid];
                });
            }
        };
    }
    return nil;
}

+ (void) initNotifications
{
    
#warning test
    
    [[DZNotificationCenter defaultCenter] addObserver:[DZAppConfigure shareConfiure] forKey:kDZSyncContextChangedMessage];
    //
    [DZNotificationCenter defaultCenter].delegate = [DZAppConfigure shareConfiure];
}

+ (void) initThirdTools
{
    [MTA startWithAppkey:DZThirdToolKeyQQMTA];
    [TestFlight takeOff:@"2ff1689d-fcae-4f55-85e4-f5fe95832705"];
}
+ (BOOL) initApp
{
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    NSString* key = @"init";
    BOOL inited =  [[[DZUserDataManager shareManager] activeUserDataForKey:key] boolValue];
    if (!inited) {
        //initTypes
        NSString* path = [[NSBundle mainBundle] pathForResource:@"InitTypesData" ofType:@"json"];
        NSData* data = [NSData dataWithContentsOfFile:path];
        NSArray* typesInitial = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingAllowFragments| NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:Nil];
        for (NSDictionary* dic  in typesInitial) {
            DZTimeType* type = [[DZTimeType alloc] initGenGUID];
            [type setValuesForKeysWithDictionary:dic];
            [DZActiveTimeDataBase updateTimeType:type];
        }
        [[DZUserDataManager shareManager] setActiveUserData:@(YES) forKey:key];
    }

    //
    [DZAppConfigure initNotifications];
    [self initThirdTools];
    [DZThemeManager shareManager];
    return YES;
}
@end
