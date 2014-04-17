//
//  DZGlobalSettingsManager.m
//  TimeUI
//
//  Created by stonedong on 14-3-30.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZGlobalSettingsManager.h"
#import "DZSingletonFactory.h"

#define NSStandarUserDefaults [NSUserDefaults standardUserDefaults]


INIT_DZ_EXTERN_STRING(kDZDefaultServerHost, www.catchitime.com)
INIT_DZ_EXTERN_STRING(kDZDefaultServerPort, 9091)



NSString* (^GlobalSettingKey)(NSString* key) = ^(NSString* key)
{
  return [NSString stringWithFormat:@"global-settings-%@",key];
};

DEFINE_NSString(serverHost)
DEFINE_NSString(ServerPort)

@implementation DZGlobalSettingsManager
+(DZGlobalSettingsManager*) shareManager
{
    return DZSingleForClass([DZGlobalSettingsManager class]);
}

- (void) setGlobalValue:(id)value forKey:(NSString*)key
{
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:GlobalSettingKey(key)];
    } else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:GlobalSettingKey(key)];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) globalValueForKey:(NSString*)key
{
    return [NSStandarUserDefaults objectForKey:GlobalSettingKey(key)];
}
- (NSString*) serverHost
{
    NSString* value = [self globalValueForKey:kDZserverHost];
    if (!value || ![value isKindOfClass:[NSString class]]) {
        return kDZDefaultServerHost;
    }
    return value;
}

- (void) setServerHost:(NSString*)str
{
    [self setGlobalValue:str forKey:kDZserverHost];
    [DZDefaultNotificationCenter postMessage:kDZNotification_ServerHostDidChanged userInfo:nil];
}


- (NSString*) serverPort
{
    NSString* value = [self globalValueForKey:kDZServerPort];
    if (!value || ![value isKindOfClass:[NSString class]]) {
        return kDZDefaultServerPort;
    }
    return value;
}
- (void) setServerPort:(NSString*)port
{
    [self setGlobalValue:port forKey:kDZServerPort];
    [DZDefaultNotificationCenter postMessage:kDZNotification_ServerHostDidChanged userInfo:nil];
}
@end


NSString* DZServerWithHostAndPort(NSString* host, NSString* port)
{
    return [NSString stringWithFormat:@"http://%@:%@/json", host, port];
}
