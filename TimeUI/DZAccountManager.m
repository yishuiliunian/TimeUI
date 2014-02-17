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

@interface DZAccountManager ()
{
    DZAccount* _activeAccount;
}
@end

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
- (void) registerActiveAccount:(DZAccount*)account
{
    if (![account isEqual:[DZAccount defaultAccount]] && _activeAccount == [DZAccount defaultAccount]) {
        [self moveAccountDataFrom:_activeAccount aim:account];
    }
    _activeAccount = account;
}
- (DZAccount*) activeAccount
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* email = [[DZUserDataManager shareManager] activeAccountGUID];
        if (email) {
            _activeAccount = [[DZAccount alloc] initWithEmail:email];
        } else
        {
            _activeAccount = [DZAccount defaultAccount];
        }
    });
    return _activeAccount;
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
