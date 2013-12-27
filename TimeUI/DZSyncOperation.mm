//
//  DZSyncOperation.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-17.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZSyncOperation.h"
#import "DZTokenManager.h"
#import "DZRouter.h"
#import "DZTime.h"
#import "NSOperationQueue+DZ.h"
#import "DZContextManager.h"
typedef struct {
    int64_t time;
    int64_t timeType;
}DZServerVersions;

@interface DZSyncOperation ()
{
    NSString* _token;
}
@end

@implementation DZSyncOperation


+ (void) syncAccount:(DZAccount *)account
{
    DZSyncOperation* op = [[DZSyncOperation alloc] init];
    op.account = account;
    [[NSOperationQueue backgroudQueue] addOperation:op];
}

- (void) main
{
    @autoreleasepool {
        if (bDZSyncContextIsSyncing) {
            return;
        }
        DZDefaultContextManager.lastSyncError = nil;
        DZSyncContextSet(DZSyncContextSyncAppleToken);
        [[DZTokenManager shareManager] appleToken:_account.email
                                         password:_account.password
                                         response:^(NSString *token, NSError *error)
         {
             if (token) {
                 NSError* err = nil;
                 _token = token;
                 if (![self syncAllDatas:&err]) {
                     DZDefaultContextManager.lastSyncError = err;
                     DZSyncContextSet(DZSyncContextSyncError);
                 }
                 else
                 {
                     DZSyncContextSet(DZSyncContextNomal);
                 }
             }
             else
             {
                 DZDefaultContextManager.lastSyncError = error;
                 DZSyncContextSet(DZSyncContextSyncError);
             }
        }];
    }
}

- (BOOL) syncAllDatas:(NSError* __autoreleasing*)error
{
    DZServerVersions versions;
    if (![self getAllVersions:versions error:error]) {
        return NO;
    }
    if (![self updateTimes:error]) {
        return NO;
    }
    return YES;
}

- (BOOL) updateTimes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncUploadTime);
    NSArray* allTimes = [DZActiveTimeDataBase allTimes];
    for (DZTime* time  in allTimes) {
        NSDictionary* dic = [time toJsonObject];
        __unused id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodUpdateTime token:_token bodyDatas:dic error:error];
        if (*error) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) getAllVersions:( DZServerVersions &  )version error:(NSError* __autoreleasing*)error
{
    id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodVersionsGetAll token:_token bodyDatas:@{} error:error];
    if (*error) {
        return NO;
    }
    if ([sobj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)sobj;
        version.time = [dic[@"times"] longLongValue];
        version.timeType = [dic[@"types"] longLongValue];
    }
    return YES;
}

@end
