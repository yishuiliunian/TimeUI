//
//  DZAccountManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAccountManager.h"
#import "DZAccount.h"
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
        account.identifiy = @"f679058b-eb34-c6c9-0e60-afe2282ff889";
        account.email = @"aasddddss1w@1.com";
        account.password = @"1";
    });
    return account;
}
@end
