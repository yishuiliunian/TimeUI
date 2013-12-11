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

- (void) setUserData:(id)data forKey:(NSString*)key
{
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) userDataForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void) setActiveUserData:(id)data forKey:(NSString*)key
{
    [self setUserData:data forKey:DZActiveUserDataKey(key)];
}

- (id) activeUserDataForKey:(NSString*)key
{
    return [self userDataForKey:DZActiveUserDataKey(key)];
}
@end
