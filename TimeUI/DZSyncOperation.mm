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
#import "NSError+dz.h"
typedef NSError*(^DZUpdateDBObjectBlock)(NSDictionary* jsonDic);


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
    NSMutableDictionary* _serverVersions;
    id<DZTimeDBInterface> _database;
}
@end

@implementation DZSyncOperation

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _serverVersions = [NSMutableDictionary new];
    return self;
}

+ (void) syncAccount:(DZAccount *)account
{
    DZSyncOperation* op = [[DZSyncOperation alloc] init];
    op.account = account;
    [[NSOperationQueue backgroudQueue] addOperation:op];
}

- (void) main
{
    @autoreleasepool {
        NSCAssert(_account != Nil, @"account is nil");
        if (bDZSyncContextIsSyncing) {
            return;
        }
        DZDefaultContextManager.lastSyncError = nil;
        DZSyncContextSet(DZSyncContextSyncAppleToken);
        _database = [[DZDBManager shareManager] timeDBInterfaceForAccount:_account];
        [[DZTokenManager shareManager] appleToken:_account.email
                                         password:_account.password
                                         response:^(NSString *token, NSString *userGuid, NSError *error) {
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
                                         }
        ];
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
    if (![self getTimeTypes:error]) {
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
    NSArray* allTimes = [_database allChangedTimes];
    for (DZTime* time  in allTimes) {
        NSDictionary* dic = [time toJsonObject];
        __unused id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodUpdateTime token:_token bodyDatas:dic error:error];
        if (*error) {
            return NO;
        }
        [_database setTime:time localchanged:NO];
    }
    return YES;
}

- (BOOL) getEditedServerObject:(NSString*)methodKey updateBlock:(DZUpdateDBObjectBlock)block error:(NSError* __autoreleasing*)error
{
    int64_t localVersion = [_database getSyncVersion:methodKey];
    int64_t serverVersion = [_serverVersions[methodKey] longLongValue];
    for (;  localVersion < serverVersion; ) {
        NSDictionary* infos = @{REST_Param_K_Time_Get_Start_Version:@(localVersion), REST_Param_K_Time_Get_Requst_Count:@(localVersion + DZDefaultRequestCount)};
        id sobj = [DZDefaultRouter sendServerMethod:methodKey token:_token bodyDatas:infos error:error];
        if (*error) {
            return NO;
        }
        int64_t version = MAX(0, localVersion);
        if ([sobj isKindOfClass:[NSDictionary class]]) {
            NSArray* times = sobj[@"objects"];
            if ([times isKindOfClass:[NSNull class]]) {
                times = nil;
            }
            if (times && ![times isKindOfClass:[NSArray class]]) {
                if (error != NULL) {
                    *error = [NSError dzErrorWithCode:-99 message:@"解析数据数组出错"];
                }
                return NO;
            }
            for (NSDictionary* dic  in times) {
                if (block) {
                    *error  = block(dic);
                    if (*error) {
                        continue;
                    }
                }
                version = MAX([dic[@"Version"] longLongValue] , version);
            }
            if (times.count == 0) {
                localVersion = serverVersion;
            } else
            {
                localVersion = version;
            }
        }
        [_database setSyncVersion:methodKey version:localVersion];
    }
    return YES;
}

- (BOOL) getTimes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncDownloadTime);
    if (![self getEditedServerObject:DZServerMethodGetTimes updateBlock:^NSError*(NSDictionary *jsonDic) {
        DZTime* time = [[DZTime alloc] init];
        NSError* error = nil ;
        if(![time decodeFromJSONObject:jsonDic error:&error])
        {
            return error;
        }
        if (![_database updateTime:time]) {
            return _database.lastError;
        }
        return nil;
    } error:error])
    {
        return NO;
    }
    return YES;
}
- (BOOL) updateTimeTypes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncUploadType);
    
    NSArray* changedTypes = [_database allLocalChangedTypes];
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
     if (![self getEditedServerObject:DZServerMethodGetTypes updateBlock:^NSError*(NSDictionary *jsonDic) {
        DZTimeType* type = [DZTimeType new];
        NSError* error   = nil;
        if (![type decodeFromJSONObject:jsonDic error:&error]) {
            return error;
        }
        if (![_database updateTimeType:type]) {
            return _database.lastError;
        }
        return nil;
    } error:error])
     {
         return NO;
     }
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
        _serverVersions[DZServerMethodGetTimes] = @([dic[@"times"] longLongValue]);
        _serverVersions[DZServerMethodGetTypes] = @([dic[@"types"] longLongValue]);
    }
    return YES;
}

@end
