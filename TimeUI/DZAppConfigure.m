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
//
static NSString* const DZThirdToolKeyQQMTA = @"IN1Q4USC75PL";

@interface DZAppConfigure () <DZNotificationInitDelegaete>

@end

@implementation DZAppConfigure

+ (DZAppConfigure*) shareConfiure
{
    return DZSingleForClass([DZAppConfigure class]);
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
    return nil;
}

+ (void) initNotifications
{
    [DZNotificationCenter defaultCenter].delegate = [DZAppConfigure shareConfiure];
}

+ (void) initThirdTools
{
    [MTA startWithAppkey:DZThirdToolKeyQQMTA];
}
+ (BOOL) initApp
{
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //initTypes
    NSString* path = [[NSBundle mainBundle] pathForResource:@"InitTypesData" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSArray* typesInitial = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingAllowFragments| NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:Nil];
    for (NSDictionary* dic  in typesInitial) {
        DZTimeType* type = [DZTimeType new];
        [type setValuesForKeysWithDictionary:dic];
        [DZActiveTimeDataBase updateTimeType:type];
    }
    
    //
    [DZAppConfigure initNotifications];
    
    
    return YES;
}
@end
