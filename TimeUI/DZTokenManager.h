//
//  DZTokenManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DZAuthorizationResponse)(NSString*token , NSError* error);

@interface DZTokenManager : NSObject
+ (DZTokenManager*) shareManager;

- (void) appleToken:(NSString*)userEmail password:(NSString*)password response:(DZAuthorizationResponse)response;
- (void) appleActiveToken:(DZAuthorizationResponse)response;

@end
