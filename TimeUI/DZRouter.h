//
//  DZRouter.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZNetworkDefines.h"

#define DZDefaultRouter [DZRouter defaultRouter]

@interface DZRouter : NSObject
@property (nonatomic, strong) NSURL* baseURL;
+ (DZRouter*) defaultRouter;
- (NSMutableURLRequest*) requstWithHttpMethod:(NSString*)httpMethod
                                        token:(NSString*)token
                                 serverMethod:(NSString*)serverMethod
                                    bodyDatas:(NSDictionary*)bodyDatas
                                        error:(NSError* __autoreleasing *)error;

- (NSMutableURLRequest*) accountRequstWithMethod:(NSString*)serverMethod
                                       bodyDatas:(NSDictionary*)bodyDatas
                                           error:(NSError* __autoreleasing *)error;
- (id) sendAccountMethod:(NSString*)serverMethod
               bodyDatas:(NSDictionary*)bodyDatas
                   error:(NSError* __autoreleasing *)error;
@end
