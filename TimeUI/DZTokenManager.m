//
//  DZTokenManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTokenManager.h"
#import "DZSingletonFactory.h"
#import "DZRouter.h"
#import "DZNetworkDefines.h"
#import "NSError+dz.h"
#import "DZAccountManager.h"

@interface DZTokenManager ()
{
    NSMutableDictionary* _tokensMap;
    NSMutableDictionary* _userGuidMap;
}
@end

@implementation DZTokenManager


- (instancetype) init
{
    self = [super init];
    if (self) {
        _tokensMap = [NSMutableDictionary new];
        _userGuidMap = [NSMutableDictionary new];
    }
    return self;
}

+ (DZTokenManager*) shareManager
{
    return DZSingleForClass([DZTokenManager class]);
}

- (BOOL) updateToken:(NSString*)token error:(NSError* __autoreleasing * )error
{
    NSDictionary* infos = @{@"token":token};
    [DZDefaultRouter sendAccountMethod:DZServerMethodTokenUpdate bodyDatas:infos error:error];
    if (*error) {
        return  NO;
    }
    return YES;
}


- (NSString*) appleForNewToken:(NSString*)userEmail password:(NSString *)password error:(NSError* __autoreleasing * )error
{
    NSDictionary* dic = @{@"email":userEmail, @"password":password};
    id serverObject = [DZDefaultRouter sendAccountMethod:DZServerMethodUserLogin bodyDatas:dic error:error];
    if (*error) {
        return nil;
    }
    if ([serverObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary* userInfo = (NSDictionary*)serverObject;
        NSString* token = userInfo[@"token"];
        NSString* userGuid = userInfo[@"userGuid"];
        if (userGuid) {
            _userGuidMap[userEmail] = userGuid;
        }
        if (token)  {
            _tokensMap[userEmail] = token;
            return token;
        }
    }
    if (error != NULL) {
        *error = [NSError dzErrorWithCode:-4 message:@"server error no token"];
    }
    return nil;
}

- (void) appleToken:(NSString *)userEmail password:(NSString *)password response:(DZAuthorizationResponse)response
{
    BOOL isActionFromMain = [[NSThread currentThread] isMainThread];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSString* token = _tokensMap[userEmail];
        NSError* error = nil;
        if (token) {
            [self updateToken:token error:&error];
        }
        else
        {
            token = [self appleForNewToken:userEmail password:password error:&error];
        }
        NSString* guid = _userGuidMap[userEmail];
        if (isActionFromMain) {
            dispatch_async(dispatch_get_main_queue(), ^{
                response(token, guid,error);
            });
        } else {
            response(token,guid, error);
        }
    });
}


- (void) appleActiveToken:(DZAuthorizationResponse)response
{
    DZAccount* account = DZActiveAccount;
    [self appleToken:account.email password:account.password response:response];
}

@end
