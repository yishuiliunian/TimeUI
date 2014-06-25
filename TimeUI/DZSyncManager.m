//
//  DZSyncManager.m
//  TimeUI
//
//  Created by stonedong on 14-6-24.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSyncManager.h"
#import "DZSingletonFactory.h"
#import "DZAccountManager.h"
#import "DZSyncOperation.h"
@implementation DZSyncManager
+ (DZSyncManager*) shareManager
{
    return DZSingleForClass([DZSyncManager class]);
}

- (void) sync
{
    if (DZActiveAccount == [DZAccount defaultAccount] || !(DZActiveAccount.isLogin)) {
        return;
    }
    [DZSyncOperation syncAccount:DZActiveAccount];
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:60*60*3 target:self selector:@selector(sync) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
    return self;
}
@end
