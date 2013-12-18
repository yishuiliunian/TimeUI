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
        [[DZTokenManager shareManager] appleToken:_account.email
                                         password:_account.password
                                         response:^(NSString *token, NSError *error)
         {
             if (token) {
                 _token = token;
                 [self updateTimes];
             }
            
        }];
    }
}

- (void) updateTimes
{
    NSError* error = nil;
    NSArray* allTimes = [DZActiveTimeDataBase allTimes];
    for (DZTime* time  in allTimes) {
        NSDictionary* dic = [time toJsonObject];
        id sobj = [DZDefaultRouter sendServerMethod:DZServerMethodUpdateTime token:_token bodyDatas:dic error:&error];
        NSLog(@"%@ \n %@", error, sobj);
    }
}

@end
