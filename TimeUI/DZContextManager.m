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
@interface DZContextManager ()

@end

@implementation DZContextManager

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

@end
