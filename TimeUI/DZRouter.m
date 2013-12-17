//
//  DZRouter.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZRouter.h"
#import "DZSingletonFactory.h"
#import "DZNetworkDefines.h"
#import "DZDevices.h"

@implementation DZRouter

+ (DZRouter*) defaultRouter
{
    return DZSingleForClass([DZRouter class]);
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _baseURL = [NSURL URLWithString:@"http://127.0.0.1:9091/json"];
    return self;
}

- (NSData*) addCommonInfos:(NSMutableDictionary*)body
           serverMethod:(NSString*)serverMethod
              bodyDatas:(NSDictionary*)bodyDatas
                  token:(NSString*)token
                  error:(NSError* __autoreleasing *)error

{
    [body setObject:serverMethod forKey:DZServerCommonKeyMethod];
    if (token) {
        [body setObject:token forKey:DZServerCommonKeyToken];
    }
    [body setObject:@"iphone" forKey:DZServerCommonKeyClientType];
    if (bodyDatas) {
        [body setObject:bodyDatas forKey:DZServerCommonKeyData];
    }
    [body setObject:DZDevicesIdentify() forKey:DZServerCommonKeyDeviceIdentify];
    NSData* data =[NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:error];
    return data;
}

- (NSMutableURLRequest*) requstWithHttpMethod:(NSString*)httpMethod
                                        token:(NSString*)token
                                 serverMethod:(NSString*)serverMethod
                                    bodyDatas:(NSDictionary*)bodyDatas
                                        error:(NSError* __autoreleasing *)error
{
    NSMutableURLRequest* requst = [NSMutableURLRequest requestWithURL:_baseURL];
    requst.HTTPMethod  = HttpMethodPost;
    requst.HTTPBody = [self addCommonInfos:[NSMutableDictionary new]
                              serverMethod:serverMethod bodyDatas:bodyDatas token:token error:error];
    return requst;
}



- (NSMutableURLRequest*) accountRequstWithMethod:(NSString*)serverMethod
                                       bodyDatas:(NSDictionary*)bodyDatas
                                           error:(NSError* __autoreleasing *)error
{
    return [self requstWithHttpMethod:HttpMethodPost
                                token:nil
                         serverMethod:DZServerMethodRegiserUser
                            bodyDatas:bodyDatas error:error];
}


- (id) sendAccountMethod:(NSString*)serverMethod
               bodyDatas:(NSDictionary*)bodyDatas
                   error:(NSError* __autoreleasing *)error
{
    NSURLRequest* request = [DZDefaultRouter accountRequstWithMethod:DZServerMethodUserLogin bodyDatas:bodyDatas error:error];
    if (*error) {
        return nil;
    }
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:error];
    if (*error) {
        return nil;
    }
    id serverObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:error];
    if (*error) {
        return nil;
    }
    return serverObject;
}
@end
