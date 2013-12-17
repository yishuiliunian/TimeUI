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
@implementation DZTokenManager

+ (DZTokenManager*) shareManager
{
    return DZSingleForClass([DZTokenManager class]);
}

- (void) appleToken:(NSString *)userEmail password:(NSString *)password response:(DZAuthorizationResponse)response
{
    BOOL isActionFromMain = [[NSThread currentThread] isMainThread];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary* dic = @{@"email":userEmail, @"password":password};
        NSError* error = nil;
    
        id serverObject = [DZDefaultRouter sendAccountMethod:DZServerMethodUserLogin bodyDatas:dic error:&error];
        if (!error) {
            if ([serverObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary* userInfo = (NSDictionary*)serverObject;
                NSString* token = userInfo[@"token"];
                if (token) {
                    if (isActionFromMain) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            response(token, error);
                        });
                    } else {
                        response(token, error);
                    }
                    return ;
                }
                else
                {
                    error = [NSError dzErrorWithCode:-4 message:@"server error no token"];
                }
            }
            else
            {
                error = [NSError dzErrorWithCode:-4 message:@"server error no token"];
            }

        }
        if (isActionFromMain) {
            dispatch_async(dispatch_get_main_queue(), ^{
                response(nil, error);
            });
        } else {
            response(nil, error);
        }
        return ;
    });
}


- (void) appleActiveToken:(DZAuthorizationResponse)response
{
    DZAccount* account = DZActiveAccount;
    [self appleToken:account.email password:account.password response:response];
}

@end
