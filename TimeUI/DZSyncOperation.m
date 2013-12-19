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
        DZSyncContextSet(DZSyncContextSyncAppleToken);
        [[DZTokenManager shareManager] appleToken:_account.email
                                         password:_account.password
                                         response:^(NSString *token, NSError *error)
         {
             if (token) {
                 _token = token;
                 NSError* err = nil;
                 [self updateTimes:&err];
                 if (err) {
                     DZSyncContextSet(DZSyncContextSyncError);
                 }
             }
             else
             {
                 DZSyncContextSet(DZSyncContextSyncError);
             }
        }];
    }
}

- (BOOL) updateTimes:(NSError* __autoreleasing*)error
{
    DZSyncContextSet(DZSyncContextSyncUploadTime);
    NSArray* allTimes = [DZActiveTimeDataBase allTimes];
    for (DZTime* time  in allTimes) {
        NSDictionary* dic = [time toJsonObject];
        __unused id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodUpdateTime token:_token bodyDatas:dic error:error];
        if (error) {
            return NO;
        }
    }
    return YES;
}

@end
