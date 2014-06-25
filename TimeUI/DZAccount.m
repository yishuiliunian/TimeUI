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


static NSString* const kDZAccountIsLogin = @"islogin";

static NSString* const kDZDefaultAccountGUID = @"b58a76b4-a3e5-47dd-0d1f-34bed9f7602f";
static NSString* const kDZDefaultAccountEmail = @"aasddddss1w@1.com";
static NSString* const kDZdefaultAccountPassword = @"1";

static NSString* const kDZDBName                       = @"time.db";

static NSString* const kDZCatchITimeService            = @"com.catchitime.accounts";
static NSString* const kDZCatchITimeServiceAccountData = @"com.catchitime.accounts.data";
@implementation DZAccount
@synthesize isLogin = _isLogin;

+ (DZAccount*) defaultAccount
{
    static DZAccount* account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[DZAccount alloc] init];
        account.identifiy = kDZDefaultAccountGUID;
        account.email = kDZDefaultAccountEmail;
        account.password = kDZdefaultAccountPassword;
    });
    return account;
}
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
    [[DZUserDataManager shareManager] setUserData:@(_isLogin) forKey:kDZAccountIsLogin user:_identifiy];
}

- (void) setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [[DZUserDataManager shareManager] setUserData:@(isLogin) forKey:kDZAccountIsLogin user:_identifiy];
}

- (BOOL) isLogin
{
    _isLogin = [[[DZUserDataManager shareManager] userDataForKey:kDZAccountIsLogin user:_identifiy] boolValue];
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

- (NSString*) analysisModelPathWithKey:(NSString *)key
{
    NSString* analysisPath = [self.documentsPath stringByAppendingPathComponent:@"analysis"];
    [DZFileUtility ensurePathExists:analysisPath];
    return [analysisPath stringByAppendingPathComponent:key];
}
@end
