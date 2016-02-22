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
#import "DZUserDataManager.h"
#import "DZSelecteTypeInterface.h"
#import "DZAnalysisNotificationInterface.h"
#import "DZMChangedAccountNI.h"
#import "DZChangedTypesNI.h"
#import <ShareSDK/ShareSDK.h>
#import "DZLocalNotificationCenter.h"
//
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "DZSyncManager.h"
#import <iRate.h>
#import "DZRestoreTrickDataNI.h"
#import "NSDate+SSToolkitAdditions.h"
#import <NSDate-TKExtensions.h>
#import <Bugly/CrashReporter.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <WeiboSDK.h>
#import <WXApi.h>
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
    } else if ([message isEqualToString:kDZNotification_AnalaysisAllCost])
    {
        return ^(id observer, NSDictionary *userInfo) {
            if ([observer respondsToSelector:@selector(parasedAllTimeCost)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer parasedAllTimeCost];
                });
            }
        };
    }
    else if([message isEqualToString:kDZNotification_changed_account])
    {
        return ^(id observer, NSDictionary *userInfo)
        {
            DZAccount* old = userInfo[@"old"];
            DZAccount* other = userInfo[@"new"];
            if ([observer respondsToSelector:@selector(didChangedAccount:toAccount:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer didChangedAccount:old toAccount:other];
                });
            }
        };
    } else if ([message isEqualToString:kDZNotification_ServerHostDidChanged])
    {
        return ^(id observer, NSDictionary* userInfo)
        {
            if ([observer respondsToSelector:@selector(serverHostDidChanged)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer serverHostDidChanged];

                });
            }
        };
    } else if ([message isEqualToString:kDZNotification_TypesChanged])
    {
        return ^(id observer, NSDictionary* userInfo)
        {
            DZTimeType* type = userInfo[@"type"];
            NSString* method = userInfo[@"method"];
            
            if ([method isEqualToString:kDZTypesChangedAdd]) {
                if ([observer respondsToSelector:@selector(handleMessageDidAddType:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [observer handleMessageDidAddType:type];

                    });
                }
            } else if ([method isEqualToString:kDZTypesChangedRemove])
            {
                if ([observer respondsToSelector:@selector(handleMessageDidRemoveType:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [observer handleMessageDidRemoveType:type];

                    });
                }
            } else if ([method isEqualToString:kDZTypesChangedModified])
            {
                SendSelectorToObjectInMainThread(@selector(handleMessageDidMofifiedType:), observer, type);
            }
            
        };
    } else if ([message isEqualToString:kDZNotification_DidReloadTypes])
    {
        return ^(id observer, NSDictionary* userInfo)
        {
            if ([observer respondsToSelector:@selector(globalDidReloadTypes)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer globalDidReloadTypes];

                });
            }
        };
    } else if ([message isEqualToString:kDZNotification_restoreDate]) {
        return ^(id observer, NSDictionary* userInfo)
        {
            if ([observer respondsToSelector:@selector(didGetRestoreTrickDateMessage)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [observer didGetRestoreTrickDateMessage];
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
//    [TestFlight takeOff:@"2ff1689d-fcae-4f55-85e4-f5fe95832705"];
}
+ (BOOL) initApp
{
    
    [[CrashReporter sharedInstance] installWithAppId:@"900019157"];
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
        
//        
//        NSDate* dateBegin = [[NSDate date] TKDateByMovingToBeginningOfDay];
//        for (int i = 1 ; i < 5; i++) {
//            DZTimeType* type = [DZTimeType randomType];
//            id<DZTimeDBInterface> db = DZActiveTimeDataBase;
//            
//            [db updateTimeType:type];
//            NSDate* dateEnd = [dateBegin dateByAddingTimeInterval:6*60*60];
//            DZTime* time = [[DZTime alloc] initWithType:type begin:dateBegin end:dateEnd detal:@""];
//            [db updateTime:time];
//            
//            dateBegin = dateEnd;
//        }
    }
    //
    [DZAppConfigure initNotifications];
    [self initThirdTools];
    [DZThemeManager shareManager];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[DZLocalNotificationCenter defaultCenter] repostAllNotifications];
        DZSyncShareManager;
        [self initializeRate];
    });
    [self initShareSDK];
    
    return YES;
}

+ (void)initializeRate
{
    //overriding the default iRate strings
    
#define iRateShareInstance [iRate sharedInstance]
    if ([[iRate sharedInstance] shouldPromptForRating]) {
        iRateShareInstance.appStoreID = 907821391;
        iRateShareInstance.applicationName = @"时间猎人";
        [iRate sharedInstance].messageTitle = @"亲，给个好评呗！";
        [iRate sharedInstance].message = @"如果你觉得这个应用不错，就给个好评，让更多的小伙伴一起来用吧。";
        [iRate sharedInstance].cancelButtonLabel = @"忙着呢，没时间";
        [iRate sharedInstance].remindButtonLabel = @"过一会儿再说吧";
        [iRate sharedInstance].rateButtonLabel = @"好，现在就去给好评";
        [[iRate sharedInstance] promptForRating];
    }
}
+ (void)initializePlat
{
    [ShareSDK registerApp:@"21244748923e"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
       
                 break;
             default:
                 break;
         }
     }];
}

+ (void) initShareSDK
{
    [self initializePlat];
}
@end
