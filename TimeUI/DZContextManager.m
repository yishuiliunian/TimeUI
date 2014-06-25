//
//  DZContextManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZContextManager.h"
#import "DZSingletonFactory.h"
#import "DZNotificationCenter.h"
#import "DZUserDataManager.h"
@interface DZContextManager ()

@end

@implementation DZContextManager
@synthesize lastSyncDate = _lastSyncDate;
+ (DZContextManager*) shareManager
{
    return DZSingleForClass([DZContextManager class]);
}
- (void) setCurrentSyncContext:(DZSyncContext)currentSyncContext
{
    DZSyncContext old = _currentSyncContext;
    if (_currentSyncContext != currentSyncContext) {
        _currentSyncContext = currentSyncContext;
        NSDictionary* userInfo = @{@"old":@(old), @"new":@(_currentSyncContext)};
        [[DZNotificationCenter defaultCenter] postMessage:kDZSyncContextChangedMessage userInfo:userInfo];
    }
}

- (void) setLastSyncDate:(NSDate *)lastSyncDate
{
    if (_lastSyncDate != lastSyncDate) {
        [[DZUserDataManager shareManager] setActiveUserData:lastSyncDate forKey:@"lastSyncDate"];
        _lastSyncDate = lastSyncDate;
    }
}

- (NSDate*) lastSyncDate
{
    if (!_lastSyncDate) {
        _lastSyncDate = [[DZUserDataManager shareManager] activeUserDataForKey:@"lastSyncDate"];
    }
    return _lastSyncDate;
}

@end
