//
//  DZAccountManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAccountManager.h"
#import "DZAccount.h"
#import "DZUserDataManager.h"
@implementation DZAccountManager
+ (DZAccountManager*) shareManager
{
    static DZAccountManager* share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[DZAccountManager alloc] init];
    });
    return share;
}

- (DZAccount*) activeAccount
{
    static DZAccount* account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[DZAccount alloc] init];
        account.identifiy = @"b58a76b4-a3e5-47dd-0d1f-34bed9f7602f";
        account.email = @"aasddddss1w@1.com";
        account.password = @"1";
    });
    return account;
}

- (void) moveAccountDataFrom:(DZAccount*)origin aim:(DZAccount*)aim
{
    id<DZTimeDBInterface> originDb  = [[DZDBManager shareManager] timeDBInterfaceForAccount:origin];
    id<DZTimeDBInterface> aimDb = [[DZDBManager shareManager] timeDBInterfaceForAccount:aim];
    NSArray* allTimes = [originDb allTimes];
    for (DZTime* time  in allTimes) {
        [aimDb updateTime:time];
    }
    NSArray* allTypes = [originDb allTimeTypes];
    for (DZTimeType* type  in allTypes) {
        [aimDb updateTimeType:type];
    }
    [[DZUserDataManager shareManager] moveSettingsFrom:origin aim:aim];
}

@end
