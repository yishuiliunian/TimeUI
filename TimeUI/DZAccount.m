//
//  DZAccount.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAccount.h"
#import "DZFileUtility.h"
#import <SSKeychain.h>
#import "DZUserDataManager.h"

static NSString* const kDZDBName                       = @"time.db";

static NSString* const kDZCatchITimeService            = @"com.catchitime.accounts";
static NSString* const kDZCatchITimeServiceAccountData = @"com.catchitime.accounts.data";
@implementation DZAccount
@synthesize isLogin = _isLogin;
- (void) setIdentifiy:(NSString *)identifiy
{
    if (_identifiy != identifiy) {
        _identifiy = identifiy;
    }
}

- (NSString*) documentsPath
{
    NSString* path = [DZFileUtility userDocumentsPath:self.identifiy];
    [DZFileUtility ensurePathExists:path];
    return path;
}

- (void) synchronize
{
    [SSKeychain setPassword:_password forService:kDZCatchITimeService account:_email];
    [SSKeychain setPassword:_password forService:kDZCatchITimeService account:_identifiy];
    [SSKeychain setPassword:_email forService:kDZCatchITimeServiceAccountData account:_identifiy];
    [SSKeychain setPassword:_identifiy forService:kDZCatchITimeServiceAccountData account:_email];
    [[DZUserDataManager shareManager] setUserData:@(_isLogin) forKey:@"islogin" user:_identifiy];
    
}

- (void) setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [[DZUserDataManager shareManager] setUserData:@(isLogin) forKey:@"islogin" user:_identifiy];
}

- (BOOL) isLogin
{
    _isLogin = [[[DZUserDataManager shareManager] userDataForKey:@"islogin" user:_identifiy] boolValue];
    return _isLogin;
}

- (instancetype) initWithEmail:(NSString*)email
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _email = email;
    _password = [SSKeychain passwordForService:kDZCatchITimeService account:email];
    _identifiy = [SSKeychain passwordForService:kDZCatchITimeServiceAccountData account:_email];
    return self;
}


- (NSString*) timeDatabasePath
{
    return [self.documentsPath stringByAppendingPathComponent:kDZDBName];
}
@end
