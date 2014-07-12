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
#import "DZMChangedAccountNI.h"
#import "DZChangedTypesNI.h"
#import <ShareSDK/ShareSDK.h>
#import "DZLocalNotificationCenter.h"
//
#import <RennSDK/RennSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Pinterest/Pinterest.h>
#import "WeiboApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "DZSyncManager.h"
#import <iRate.h>
#import "DZRestoreTrickDataNI.h"
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
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[DZLocalNotificationCenter defaultCenter] repostAllNotifications];
        DZSyncShareManager;
    });
    [self initShareSDK];
    [self initializeRate];
    return YES;
}

+ (void)initializeRate
{
    //overriding the default iRate strings
    if ([[iRate sharedInstance] shouldPromptForRating]) {
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
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接Facebook应用以使用相关功能，此应用需要引用FacebookConnection.framework
     https://developers.facebook.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    /**
     连接Twitter应用以使用相关功能，此应用需要引用TwitterConnection.framework
     https://dev.twitter.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接Google+应用以使用相关功能，此应用需要引用GooglePlusConnection.framework、GooglePlus.framework和GoogleOpenSource.framework库
     https://code.google.com/apis/console上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectGooglePlusWithClientId:@"232554794995.apps.googleusercontent.com"
                               clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                redirectUri:@"http://localhost"
                                  signInCls:[GPPSignIn class]
                                   shareCls:[GPPShare class]];
    

    
    /**
     连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
     http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
                            appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    

    //连接邮件
    [ShareSDK connectMail];
    
    //连接打印
    [ShareSDK connectAirPrint];
    
    //连接拷贝
    [ShareSDK connectCopy];
    
    /**
     连接搜狐微博应用以使用相关功能，此应用需要引用SohuWeiboConnection.framework
     http://open.t.sohu.com上注册搜狐微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuWeiboWithConsumerKey:@"q70QBQM9T0COxzYpGLj9"
                               consumerSecret:@"XXYrx%QXbS!uA^m2$8TaD4T1HQoRPUH0gaG2BgBd"
                                  redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接网易微博应用以使用相关功能，此应用需要引用T163WeiboConnection.framework
     http://open.t.163.com上注册网易微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    
    /**
     连接豆瓣应用以使用相关功能，此应用需要引用DouBanConnection.framework
     http://developers.douban.com上注册豆瓣社区应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
                            appSecret:@"9f1e7b4f71304f2f"
                          redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接印象笔记应用以使用相关功能，此应用需要引用EverNoteConnection.framework
     http://dev.yinxiang.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"sharesdk-7807"
                       consumerSecret:@"d05bf86993836004"];
    
    /**
     连接LinkedIn应用以使用相关功能，此应用需要引用LinkedInConnection.framework库
     https://www.linkedin.com/secure/developer上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectLinkedInWithApiKey:@"ejo5ibkye3vo"
                              secretKey:@"cC7B2jpxITqPLZ5M"
                            redirectUri:@"http://sharesdk.cn"];

    
    /**
     连接Pocket应用以使用相关功能，此应用需要引用PocketConnection.framework
     http://getpocket.com/developer/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectPocketWithConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
                               redirectUri:@"pocketapp1234"];
    
    /**
     连接Instapaper应用以使用相关功能，此应用需要引用InstapaperConnection.framework
     http://www.instapaper.com/main/request_oauth_consumer_token上注册Instapaper应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    
    /**
     连接有道云笔记应用以使用相关功能，此应用需要引用YouDaoNoteConnection.framework
     http://note.youdao.com/open/developguide.html#app上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
    
    /**
     连接搜狐随身看应用以使用相关功能，此应用需要引用SohuConnection.framework
     https://open.sohu.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
                             appSecret:@"b8eec53707c3976efc91614dd16ef81c"
                           redirectUri:@"http://sharesdk.cn"];
    
    
    /**
     链接Flickr,此平台需要引用FlickrConnection.framework框架。
     http://www.flickr.com/services/apps/create/上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectFlickrWithApiKey:@"33d833ee6b6fca49943363282dd313dd"
                            apiSecret:@"3a2c5b42a8fbb8bb"];
    
    /**
     链接Tumblr,此平台需要引用TumblrConnection.framework框架
     http://www.tumblr.com/oauth/apps上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectTumblrWithConsumerKey:@"2QUXqO9fcgGdtGG1FcvML6ZunIQzAEL8xY6hIaxdJnDti2DYwM"
                            consumerSecret:@"3Rt0sPFj7u2g39mEVB3IBpOzKnM3JnTtxX2bao2JKk4VV1gtNo"
                               callbackUrl:@"http://sharesdk.cn"];
    
    /**
     连接Dropbox应用以使用相关功能，此应用需要引用DropboxConnection.framework库
     https://www.dropbox.com/developers/apps上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectDropboxWithAppKey:@"7janx53ilz11gbs"
                             appSecret:@"c1hpx5fz6tzkm32"];
    
    /**
     连接Instagram应用以使用相关功能，此应用需要引用InstagramConnection.framework库
     http://instagram.com/developer/clients/register/上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectInstagramWithClientId:@"ff68e3216b4f4f989121aa1c2962d058"
                              clientSecret:@"1b2e82f110264869b3505c3fe34e31a1"
                               redirectUri:@"http://sharesdk.cn"];
    
    /**
     连接VKontakte应用以使用相关功能，此应用需要引用VKontakteConnection.framework库
     http://vk.com/editapp?act=create上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectVKontakteWithAppKey:@"3921561"
                               secretKey:@"6Qf883ukLDyz4OBepYF1"];
}

+ (void) initShareSDK
{
    [ShareSDK registerApp:@"21244748923e"];


//    [ShareSDK connectSinaWeiboWithAppKey:@"1227875931"
//                               appSecret:@"8ca96c2a25b61888c8d41bf3f2695cd3"
//                             redirectUri:@"www.weibo.com"];
    [ShareSDK connectSMS];
    [ShareSDK connectCopy];
    [ShareSDK connectMail];
    [ShareSDK connectAirPrint];
    
    [self initializePlat];
}
@end
