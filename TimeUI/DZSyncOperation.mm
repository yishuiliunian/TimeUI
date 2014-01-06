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
#import "DZTimeType.h"
typedef struct {
    int64_t time;
    int64_t timeType;
}DZServerVersions;

static NSString* REST_Param_K_Time_Get_Start_Version = @"start_version";
static NSString* REST_Param_K_Time_Get_Requst_Count = @"request_cout";

static float const DZDefaultRequestCount = 100;

@interface DZSyncOperation ()
{
    NSString* _token;
    DZServerVersions _serverVersions;
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
    if (![self getAllVersions:error]) {
        return NO;
    }
    if (![self getTimes:error]) {
        return NO;
    }
    if (![self updateTimes:error]) {
        return NO;
    }
    if (![self updateTimeTypes:error]) {
        return NO;
    }
    return YES;
}

- (BOOL) updateTimes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncUploadTime);
    NSArray* allTimes = [DZActiveTimeDataBase allChangedTimes];
    for (DZTime* time  in allTimes) {
        NSDictionary* dic = [time toJsonObject];
        __unused id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodUpdateTime token:_token bodyDatas:dic error:error];
        if (*error) {
            return NO;
        }
        [DZActiveTimeDataBase setTime:time localchanged:NO];
    }
    return YES;
}

- (BOOL) getTimes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncDownloadTime);
    int64_t localVersion = [DZActiveTimeDataBase timeVersion];
    for (; localVersion < _serverVersions.time; ) {
        NSDictionary* infos = @{REST_Param_K_Time_Get_Start_Version:@(localVersion), REST_Param_K_Time_Get_Requst_Count:@(localVersion + DZDefaultRequestCount)};
        id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodGetTimes token:_token bodyDatas:infos error:error];
        if (*error) {
            break;
        }
        int64_t version = localVersion;
        if ([sobj isKindOfClass:[NSDictionary class]]) {
            NSArray* times = sobj[@"times"];
            if (![times isKindOfClass:[NSDictionary class]]) {
                break;
            }
            for (NSDictionary* dic  in times) {
                version = MAX([dic[@"Version"] longLongValue] , version);
                DZTime* time = [[DZTime alloc] init];
                [time setValuesForKeysWithDictionary:dic];
                if (!time.isMarshalSucceed) {
                    continue;
                }
                [DZActiveTimeDataBase updateTime:time];
                NSLog(@"%@",time);
            }
        }
        localVersion = version;
    }
    [DZActiveTimeDataBase setTimeVersion:localVersion];
    if (*error) {
        return NO;
    }
    return YES;
}
- (BOOL) updateTimeTypes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncUploadType);
    
    NSArray* changedTypes = [DZActiveTimeDataBase allLocalChangedTypes];
    for (DZTimeType* type  in changedTypes) {
        NSDictionary* jsonType = [type toJsonObject];
        id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodUpdateType token:_token bodyDatas:jsonType error:error];
        NSLog(@"%@",sobj);
        if (*error) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) getTimeTypes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncDownloadType);
    
    
    
    return YES;
}

- (BOOL) getAllVersions:(NSError* __autoreleasing*)error
{
    id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodVersionsGetAll token:_token bodyDatas:@{} error:error];
    if (*error) {
        return NO;
    }
    if ([sobj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)sobj;
        _serverVersions.time = [dic[@"times"] longLongValue];
        _serverVersions.timeType = [dic[@"types"] longLongValue];
    }
    return YES;
}

@end
