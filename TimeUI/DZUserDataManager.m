//
//  DZUserDataManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZUserDataManager.h"
#import "DZAccountManager.h"

NSString*(^DZUserDataKey)(NSString*userId, NSString*key) = ^(NSString*userId, NSString*key)
{
    return [NSString stringWithFormat:@"%@--%@",userId, key];
};

#define DZActiveUserDataKey(key) DZUserDataKey(DZActiveAccount.identifiy, key)

@implementation DZUserDataManager
+ (DZUserDataManager*) shareManager
{
    static DZUserDataManager* share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[DZUserDataManager alloc] init];
    });
    return share;
}

- (NSDictionary*) allUserData:(DZAccount*)account
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:account.identifiy];
}

- (void) moveSettingsFrom:(DZAccount*)origin aim:(DZAccount*)account
{
    NSDictionary* dic = [self allUserData:origin];
    if (dic) {
        [[NSUserDefaults standardUserDefaults] setObject:dic  forKey:account.identifiy];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void) setUserData:(id)data forKey:(NSString*)key user:(NSString*)userKey
{
    
    NSMutableDictionary* infos = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:userKey] mutableCopy];
    if (!infos) {
        infos = [NSMutableDictionary new];
    }
    if (data) {
        [infos setObject:data forKey:key];
    }
    else
    {
        [infos removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setObject:infos forKey:userKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) userDataForKey:(NSString*)key user:(NSString*)userKey
{
    NSDictionary* infos = [[NSUserDefaults standardUserDefaults] dictionaryForKey:userKey];
    return [infos objectForKey:key];
}

- (void) setActiveUserData:(id)data forKey:(NSString*)key
{
    [self setUserData:data forKey:key user:DZActiveAccount.identifiy];
}

- (id) activeUserDataForKey:(NSString*)key
{
    return [self userDataForKey:key user:DZActiveAccount.identifiy];
}


- (void) setInfo:(id)info forKey:(NSString *)key
{
    if (info) {
        [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) infoForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


- (void) setActiveAccountGUID:(NSString*)guid
{
    [self setInfo:guid forKey:@"active-account"];
}

- (NSString*) activeAccountGUID
{
    return [self infoForKey:@"active-account"];
}
@end
